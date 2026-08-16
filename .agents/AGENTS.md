# Home Infrastructure

Declarative configuration for a personal home lab: a Fortinet firewall, an ESXi server running NixOS VMs, bare-metal
NixOS and macOS machines, an AWS VPN endpoint, and a TrueNAS appliance. Nothing here is configured by hand.

## Read First

Start with [docs/architecture/overview.md](docs/architecture/overview.md). It explains the one split that governs
everything: **OpenTofu creates machines, Nix defines what they are.** Read the area doc for whatever you are touching
before editing:

| Area                | Doc                                                            |
|---------------------|----------------------------------------------------------------|
| Entry point scripts | [docs/architecture/bin.md](docs/architecture/bin.md)           |
| `src/docker/`       | [docs/architecture/docker.md](docs/architecture/docker.md)     |
| `src/nix/`          | [docs/architecture/nix.md](docs/architecture/nix.md)           |
| `src/opentofu/`     | [docs/architecture/opentofu.md](docs/architecture/opentofu.md) |

## Rules

**Never run builds or applies.** Do not run `nix build`, `nix eval`, `nixos-rebuild`, `darwin-rebuild`, `tofu`, or any
script in `bin/`. These change real infrastructure and are slow. Make the edit, say what changed and what it will
affect, and let the user run it.

**Never decrypt or print a secret.** `src/secrets.age` and `src/nix/module/secret/**/*.age` stay encrypted. Nix code
interpolates the *path* to a decrypted secret, never its contents -- `builtins.readFile` on a secret is always wrong,
because it would put plaintext in the Nix store.

**Do not edit generated output.** OpenCode agent Markdown is produced from a Nix capability graph; edit the
`definition.nix` and `prompt.md` sources instead. See the `create-edit-opencode-agent` skill.

## Skills

| Skill                        | Covers                                                          |
|------------------------------|-----------------------------------------------------------------|
| `create-edit-host`           | Adding, renaming, or decommissioning a machine                  |
| `create-edit-opencode-agent` | Adding or editing an OpenCode subagent and its delegation edges |
| `create-edit-quadlet`        | Adding or editing a containerized service on a Linux host       |

## Conventions

* Sort declarations **alphabetically** -- Nix `let` bindings and attribute keys, OpenTofu arguments and variable blocks.
  Not by logical grouping.
* Keep all Nix bindings in the `let` block; do not inline them inside attribute sets.
* Wrap at 120 columns. Use `--` rather than an em dash. Use `*` for bullets.
* Markdown headings use Title Case, except where the heading is a literal identifier.
* Prefer a real nix-darwin or NixOS option over an activation script. Verify an option's existence against the upstream
  manual or repository, not by searching `/nix/store` locally.
* New units are discovered by directory scan -- agenix secrets, OpenCode agents, podman quadlets. Creating the directory
  or file *is* the registration; there is rarely a list to add to.
* Documentation is concise: a short why, then the steps. No exhaustive enumerations.

## Where Things Go

| Adding                | Goes in                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| A container/service   | `src/nix/host/<type>/<host>/container/<name>/`, plus a DNS alias                 |
| A machine             | `src/nix/host/.../configuration.nix` + `flake.nix`, and an OpenTofu root         |
| A reusable Nix helper | `src/nix/module/util/`, exported from its `default.nix`                          |
| A secret              | `src/nix/module/secret/<path>.age` (per-machine) or `src/secrets.age` (OpenTofu) |
| Cross-machine config  | `vars` in `src/nix/flake.nix`; per-host differences go in `extraVars`            |
