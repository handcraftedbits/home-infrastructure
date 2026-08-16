# Entry Point Scripts (`bin/`)

Every operation in this repository is invoked through a script in `bin/`. They exist so that no tool -- `tofu`, `age`,
`govc`, `jq`, the AWS CLI -- has to be installed on the machine running them.

## What They All Do

Each script follows the same shape:

1. Parse arguments with `getopts`, supporting both short and long forms, and validate them before doing any work.
2. Source `common.sh`.
3. Call `build_image_if_necessary` for the images it needs.
4. `docker run` the image with the age key, `src/secrets.age`, and the relevant source tree bind-mounted in.

Arguments are validated eagerly and failure prints the usage block, because these commands are slow and destructive
enough that failing after a container start is a poor experience.

## `common.sh`

Shared plumbing, sourced by every script:

* `detect_container_runtime` -- prefers Docker, falls back to Podman, and locates the correct socket path for whichever
  it found. Runs automatically on source, setting `$docker` and `$docker_sock_file`.
* `build_image_if_necessary` -- compares the image's `LastTagTime` against the newest mtime in its build directory and
  rebuilds only when the source is newer. This is why no separate build step is documented anywhere: images are always
  current as a side effect of running a command.
* `get_ip_address` -- the host's LAN address, used as the bootstrap HTTP server's advertised host.
* `$is_mac` -- set once, because `date`, `stat`, and socket paths all differ between BSD and GNU userlands.

## The Scripts

| Script        | Provisions                            | Extra arguments                       |
|---------------|---------------------------------------|---------------------------------------|
| `aws.sh`      | An EC2 host from `src/opentofu/aws`   | `-d` directory                        |
| `docker.sh`   | Containers from `src/opentofu/docker` | `-d` directory                        |
| `network.sh`  | Firewall DNS/DHCP state               | none                                  |
| `physical.sh` | A bare-metal NixOS host               | `-p` HTTP server port                 |
| `vm.sh`       | An ESXi VM from `src/opentofu/vm`     | `-d` directory, `-p` HTTP server port |

All of them require `-a <age_key>`.

Arguments after the recognised flags are forwarded to `tofu`, so `bin/vm.sh -a ... -d apphost -p 8080 plan` works and is
the normal way to preview a change.

## Why Some Take a Port

`physical.sh` and `vm.sh` start a short-lived HTTP server on the *host machine* serving a `bootstrap.json` that tells
the installing system which flake to fetch and which age key to install. The new machine reaches back over the LAN to
retrieve it, which is why the port must be reachable and why `get_ip_address` matters. The other scripts drive an API
and need no inbound path.

## Per-Script Secret Filtering

The container is passed `--secrets-to-delete` and `--constants-to-delete` naming top-level keys to strip from the
decrypted variable files before handing them to `tofu`. OpenTofu rejects variables a configuration does not declare,
so each script removes the ones its target root does not use -- `network.sh` drops `esxi` and `nix`, `aws.sh` drops
`esxi` and `keys`, and so on. Adding a new variable to `src/secrets.age` may require updating these lists.

## Cache

`~/.home-infrastructure/cache` holds built NixOS installer ISOs, which are large and slow to produce. It is mounted into
the containers that need it. Deleting it is safe but costs a rebuild.
