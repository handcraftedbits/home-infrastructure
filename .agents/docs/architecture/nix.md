# Nix Configuration (`src/nix/`)

A single flake defines every machine -- NixOS VMs, bare-metal NixOS, macOS via nix-darwin, and an EC2 instance --
through one host constructor. Home Manager is embedded in every system rather than run standalone.

## Layout

```
src/nix/
  flake.nix              <- inputs, global vars, host list
  host/<type>/<name>/    <- one directory per machine
    configuration.nix
    container/<svc>/     <- podman quadlets (Linux hosts)
    service/             <- host-specific systemd units
  module/
    hardware/            <- device-specific config
    os/                  <- the OS layering hierarchy
    package/             <- per-package config, split all/linux/macos
    secret/              <- agenix definitions and *.age files
    service/             <- reusable systemd services
    util/                <- the mk* function library
```

`hostType` is one of `aws`, `physical`, or `vm`, and it is both a directory name and a behavioral switch.

## `mkHost` and the `vars` Pattern

`module/util/mkHost.nix` is the single entry point for defining a machine. `flake.nix` calls it once per host with
`hostName`, `hostType`, `mainUser`, an optional `system`, and optional `extraVars`, and it picks `darwinSystem` or
`nixosSystem` by inspecting the system string.

The important design decision is **`vars`**: a plain attribute set threaded through `specialArgs` and Home Manager's
`extraSpecialArgs`, so every module in the tree receives it without any option declarations. It is assembled by merging,
in order:

1. Global constants from `flake.nix` -- domains, timezone, NFS/CIFS servers, user identities.
2. Fixed per-host values -- `hostName`, and `user` resolved from `mainUser`.
3. **Secret paths**, derived automatically (below).
4. `extraVars`, the per-host overrides -- `work` uses this to swap the Git email, `macdesk` to name its Synergy peer.

A module wanting a new global constant adds it to `vars` in `flake.nix`; a per-host difference goes in `extraVars`.
Neither requires touching `mkHost`.

### Secret Paths Are Generated, Not Written

`mkHost` reads `module/secret/secrets.nix`, strips `.age` from every name, splits on `/`, and builds a nested attribute
set of *paths* under `/run/agenix`. So `secret/postgresql/password.age` becomes `vars.postgresql.password` =
`/run/agenix/postgresql/password`.

This is the mechanism that keeps plaintext out of the Nix store. A consumer writes `$(cat ${vars.postgresql.password})`
into a shell-evaluated context; the store only ever holds the path. Never read a secret with `builtins.readFile`.

## The OS Layering Hierarchy

`module/os/` composes by import chain rather than by conditionals:

```
all.nix                     <- every machine: nix settings, GC, timezone, base packages, hm defaults
  linux/common.nix          <- locale, users, zsh, openssh, agenix, activation scripts
    linux/internal/common.nix   <- LAN machines: podman, kernel tuning, boot loader
      linux/internal/physical.nix
      linux/internal/vm.nix     <- adds VMware guest tools
  linux/aws-minimal.nix     <- deliberately bypasses internal/, since EC2 shares almost nothing with the LAN
  macos/default.nix         <- nix-darwin: homebrew, fonts, settings, GUI packages
```

`aws-minimal.nix` sitting beside `internal/` rather than under it is intentional -- the VPN host has no NAS mounts, no
containers, and no LAN services, and forcing it through the internal layers would mean disabling most of them.

A host's `configuration.nix` imports the appropriate leaf plus whatever is specific to it, and stays short. Anything
that would be reused belongs in `module/`, not in the host file.

## The `util` Function Library

`module/util/default.nix` takes `vars` and returns partially-applied constructors. Hosts import it as
`util = import ../../../module/util { inherit vars; }` and call the members in their `imports` list.

| Function                   | Produces                                                                         |
|----------------------------|----------------------------------------------------------------------------------|
| `mkCifsMount`              | A CIFS `fileSystems` entry plus its agenix credentials file                      |
| `mkDefaultMounts`          | The standard NAS shares -- `fileSystems` on Linux, a launchd agent on macOS      |
| `mkFileWithSecrets`        | A Home Manager activation step writing a file whose content interpolates secrets |
| `mkGpuAvailabilityService` | A oneshot unit that blocks until the NVIDIA device nodes appear                  |
| `mkNfsMount`               | An NFSv4.2 `fileSystems` entry with the standard tuning options                  |
| `mkSignedApp`              | A re-signed macOS app bundle; see below                                          |
| `mkTcpAvailabilityService` | A `Type=notify` unit that stays active only while a host:port is reachable       |
| `mkUserQuadlets`           | Rootless podman containers from a directory scan; see below                      |

### Availability Services

Quadlets cannot express "start after a service on another machine is up", and podman will happily start a GPU container
before the NVIDIA device nodes exist. `mkTcpAvailabilityService` and `mkGpuAvailabilityService` fill the gap with a unit
that blocks until the resource appears.

The TCP variant additionally exits non-zero once the port stops answering, so `Restart=always` re-enters the waiting
state and anything with `Wants=`/`After=` on it is torn down and retried. That is how a database restart on one host
propagates to consumers on another -- `apphost` sequences itself behind `postgresql.db` on `datahost` this way.

### Secrets Force Regeneration

Home Manager only re-runs an activation block when its text changes, but a re-encrypted secret leaves the generated
text identical. `secretsHash.nix` hashes every `.age` file together and the result is embedded as a comment in the
activation scripts produced by `mkFileWithSecrets` and `mkUserQuadlets`. Rotating a secret changes the hash, changes the
script, and forces the rewrite.

## Containers Are Rootless Podman Quadlets

Linux hosts run services as rootless podman quadlets under the main user, not as NixOS service modules. Each service is
a directory under the host's `container/`, discovered by `readDir`, and `mkUserQuadlets` renders it into
`~/.config/containers/systemd/`.

Three decisions in that renderer are worth knowing:

* **Environment files are written at activation, not placed in the store.** They hold decrypted secret values, so they
  are produced by a mode-600 activation step rather than a store path. The store only ever holds the
  `$(cat /run/agenix/...)` expression that produces them.
* **Running units are reconciled against a hash manifest**, so a changed container restarts, a removed one stops, and a
  new one starts. Without this, `daemon-reload` would leave stale units running.
* **The file extension determines the unit name** -- `.container.nix` yields `<name>.service`, `.network.nix` yields
  `<name>-network.service`. Dependencies are written against the generated name, not the filename.

Authoring rules -- ordering conventions, secret interpolation, Traefik exposure, and how to wait on mounts, GPUs, and
services on other hosts -- live in the `create-edit-quadlet` skill.

## macOS Specifics

nix-darwin hosts get `module/os/macos/`, which layers Homebrew casks for applications that cannot be packaged in nixpkgs
on top of the normal Nix package set. System defaults are split into `settings/{dock,finder,misc}.nix`.

macOS secrets are declared explicitly in `os/macos/secrets.nix` rather than discovered, because a workstation needs only
a handful of them and the recursive scan would pull in every VM's credentials.

### `mkSignedApp`

nixpkgs signs macOS binaries ad-hoc, so every rebuild produces a new code identity and TCC permission grants
(Accessibility, Full Disk Access) are lost. `mkSignedApp` re-signs affected bundles during activation with a
self-signed `nix-codesign` certificate, giving them a stable cdhash so grants persist. It operates either in place on
an existing bundle or by synthesising a minimal `.app` around a bare binary. The certificate must be created by hand
once per machine -- see the Code Signing section of `README.md`; activation fails with a pointer to it if missing.

## OpenCode Agents

`module/package/all/hm/opencode/` generates OpenCode's agent Markdown and config from a Nix capability graph rather
than storing hand-written agent files. Agents are directories of `definition.nix` + `prompt.md`, discovered by
`readDir`, with delegation edges validated for cycles and unknown targets at eval time.

Do not edit generated output. The full authoring rules live in the `create-edit-opencode-agent` skill.

## Working on This Tree

* Add a machine: a `host/<type>/<name>/configuration.nix` plus one entry in `flake.nix`.
* Add a secret: encrypt to `module/secret/<path>.age` and it is picked up automatically, both as an agenix secret and as
  a `vars` path. Nothing else to register.
* Sort `let` bindings and attribute keys alphabetically, and keep all bindings in the `let` block rather than inline.
* Prefer a real nix-darwin or NixOS option over an activation script. Reach for `system.activationScripts` only when
  no declarative option exists, and note that only nix-darwin's predefined slots (`postActivation`, etc.) actually
  run -- a custom name is silently ignored.
* Do not run `nix build`, `nix eval`, or a rebuild as part of making a change. Make the edit and report what changed.
