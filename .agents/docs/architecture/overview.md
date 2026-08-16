# Architecture Overview

This repository declaratively manages a personal home lab: a Fortinet firewall, an ESXi server hosting several NixOS
VMs, two bare-metal machines, two macOS workstations, an AWS EC2 VPN endpoint, and a TrueNAS box. Everything that
defines those systems lives here; nothing is configured by hand.

## The Central Split

Two tools own two different halves of the problem, and the boundary between them is deliberate:

* **OpenTofu** creates *machines and network state* -- VMs, EC2 instances, DNS and DHCP entries, and the one Docker
  workload that runs on an appliance we do not control.
* **Nix** defines *what a machine is* once it exists -- packages, users, services, mounts, secrets, and containers.

OpenTofu never installs software and Nix never provisions hardware. A VM's CPU count is an OpenTofu concern; the
containers it runs are a Nix concern. When adding something, the question "does this exist before the OS boots?" decides
which tree it belongs in.

The two halves meet exactly once, at bootstrap: OpenTofu hands a new machine a URL pointing at this flake plus an age
key, and the machine installs itself from that. After that first boot, OpenTofu is out of the picture and the machine is
maintained by `nixos-rebuild`/`darwin-rebuild` against the flake.

## Everything Runs in a Container

No user is expected to have `tofu`, `age`, `govc`, or the AWS CLI installed. The scripts in `bin/` are thin argument
parsers that build a Docker image on demand and run the real work inside it. This keeps tool versions pinned in a
`Dockerfile` rather than in a README, and it means the only host requirements are Docker (or Podman) and a copy of the
age key.

See [docker.md](docker.md) for the image layout and [bin.md](bin.md) for the entry points.

## Secrets Have Two Separate Systems

There are two secret stores, for two different consumers, and conflating them is the most common mistake:

* `src/secrets.age` -- a **single encrypted JSON blob** consumed by OpenTofu. The container decrypts it at startup and
  feeds it to `tofu` as a `--var-file`. It holds ESXi credentials, AWS keys, and API tokens.
* `src/nix/module/secret/**/*.age` -- **one file per secret**, consumed by agenix on the target machine. These are
  decrypted at activation time into `/run/agenix` and referenced by path, never by value.

Both are encrypted to the same age key, which lives at `/etc/age-key` on managed machines and is passed to `bin/`
scripts with `-a`. Nix code never sees a secret's plaintext -- it only ever interpolates the *path* to a decrypted file,
so secrets never enter the Nix store. See [nix.md](nix.md#secrets) for how that path discipline is enforced.

## Repository Layout

| Path              | Contents                                                       |
|-------------------|----------------------------------------------------------------|
| `bin/`            | Host-side entry points; see [bin.md](bin.md)                   |
| `src/docker/`     | Images the entry points run; see [docker.md](docker.md)        |
| `src/nix/`        | The flake: hosts, modules, secrets; see [nix.md](nix.md)       |
| `src/opentofu/`   | Provisioning and network state; see [opentofu.md](opentofu.md) |
| `src/secrets.age` | The encrypted OpenTofu variable blob                           |

## Naming and Addressing

Everything is under `howard.estate`, structured by role rather than by machine:

* Machines get `<name>.lan.howard.estate`, with VMs at `<name>.vm.lan.howard.estate`.
* Services get a role-suffixed alias -- `forgejo.app`, `postgresql.db`, `coding.llm` -- pointing at whichever host
  currently runs them.

The alias layer is what makes a service movable. Containers reference each other by service name, so relocating a
workload between hosts is a DNS change in `src/opentofu/network/dns.tofu` plus a quadlet move, with no config edits
in the consumers.

## Conventions

These hold across the whole repository and are worth honoring in new code:

* Declarations are sorted **alphabetically** -- Nix `let` bindings, attribute keys, OpenTofu arguments, and variable
  blocks. Not by logical grouping.
* Lines wrap at 120 columns.
* New units are discovered by directory scan, not by registration in a list. Creating the directory is the act of adding
  the thing. This applies to agenix secrets, OpenCode agents, and podman quadlets.
* Markdown headings use Title Case.
