# OpenTofu Configuration (`src/opentofu/`)

OpenTofu provisions machines and network state. It stops at the point where a machine can boot and fetch its own Nix
configuration -- it never installs packages or configures services. See [nix.md](nix.md) for the other half.

## Layout

```
src/opentofu/
  modules/           <- reusable, never applied directly
    aws/ec2/
    esxi/vm/
    network/fortinet/{dhcp,dns}/
    vm/nixos/
  aws/ec2/<host>/    <- root modules, one per thing that has state
  docker/<host>/
  network/
  vm/<host>/
  vm/common/         <- variable declarations shared by the vm roots
```

Root modules are thin: `main.tofu` calls one module with concrete values, `support.tofu` declares the backend and
providers. Nearly all logic lives in `modules/`. The VM roots share their variable declarations by symlinking
`variables.tofu` to `vm/common/variables.tofu` rather than duplicating the object types.

## File Naming Convention

Every module splits by kind, and the split is consistent enough to rely on when locating something:

| File             | Contents                                      |
|------------------|-----------------------------------------------|
| `data.tofu`      | `data` blocks                                 |
| `imports.tofu`   | `import` blocks for adopting existing objects |
| `locals.tofu`    | `locals`                                      |
| `main.tofu`      | Resources and module calls                    |
| `support.tofu`   | `terraform` block, backend, providers         |
| `variables.tofu` | `variable` blocks                             |

Arguments within a block are sorted alphabetically.

## State

All state lives in S3 (`hcb-terraform-state`, `us-east-1`), keyed by the root module's path -- `vm/apphost`, `network`,
`docker/nas`. Credentials come from `~/.aws` written by the container entrypoint out of `src/secrets.age`, so no AWS
environment variables are ever set. This means the state bucket is a hard prerequisite for every command, including ones
that never otherwise touch AWS.

## Variables Are Injected, Not Declared

Root modules declare variables such as `esxi`, `keys`, `nix`, and `http_server` but nothing ever sets them in a
`.tfvars` file in the repository. The container passes two `--var-file` arguments at exec time: the decrypted secrets
and the baked-in constants. See [docker.md](docker.md#infrastructure-runner).

Because OpenTofu rejects undeclared variables, each entry point strips the keys its target does not use. Adding a new
top-level secret means checking those `--secrets-to-delete` lists in `bin/`.

Complex variables use an object type with a heredoc `description` documenting each field. Numeric variables carry
`validation` blocks asserting integrality and positivity. Follow both when adding one.

## `modules/vm/nixos` -- The Bootstrap Orchestrator

This is the most involved module and the one that encodes the Nix handoff. It sequences four steps with `depends_on`,
using `null_resource` with `triggers = { run = "once" }` so they fire exactly once at create time:

1. `null_resource.iso` -- build the unattended installer ISO for this bootstrap URL.
2. `null_resource.start_host` -- start the `bootstrap.json` HTTP server.
3. `module.esxi_vm` -- create the VM, which boots the ISO, fetches the bootstrap document, and installs itself.
4. `null_resource.stop_host` -- shut the HTTP server down.

The provisioners are `local-exec` calls to scripts that exist inside `infrastructure-runner`, at absolute paths under
`/opt/container/bin`. That coupling is why OpenTofu here is only ever run through `bin/`, never directly.

`extra_config` and `pci_device_ids` pass through to the ESXi module, which is how `aihost` gets its GPUs.

## `modules/esxi/vm`

Creates the VM itself: uploads the ISO to the datastore, creates the `vsphere_virtual_machine`, and then runs
`remove-cdrom-and-add-pci-devices.sh`.

Two decisions worth knowing:

* **MAC addresses are derived, not assigned.** `locals.tofu` takes `md5(hostname)`, prefixes `02` (locally
  administered), and uses the first five bytes. A host therefore has a stable MAC determined by its name alone, which
  is what lets `src/opentofu/network/dhcp.tofu` reserve its IP without any cross-module reference. Renaming a host
  changes its MAC and requires updating the DHCP reservation.
* **PCI passthrough happens outside the resource**, in the `govc` script, because the vSphere provider cannot reference
  the VM's own ID during provisioning. `memory_reservation` is set to full RAM whenever devices are passed through, as
  passthrough requires it.

`cdrom` is in `lifecycle.ignore_changes` since the script removes it after install and the provider would otherwise try
to put it back.

## `modules/aws/ec2`

Simpler, because EC2 has `user_data`. `locals.tofu` renders `data/user_data.template` with a base64 age key and the
flake URLs; the script writes the key, adds swap, clones the flake, and runs
`nixos-rebuild switch --flake ... --impure`, guarding on `/etc/install-finished` so a reboot does not repeat it. It
clones over anonymous HTTPS, then rewrites the remote to the SSH URL so later manual pulls authenticate normally.

The module also creates the security group, a default SSH ingress rule extended by `additional_ingress_rules`, and a
Route 53 A record.

## `network/` -- Adopted, Not Created

The Fortinet firewall's DNS zone and DHCP server already existed. `imports.tofu` adopts them by ID rather than creating
new ones, and `main.tofu` in the DHCP module looks its own ID up through a data source with `try(...)`. Treat these
roots as *managing* pre-existing objects: a `destroy` here removes real firewall configuration.

`dns.tofu` is the source of truth for the naming scheme described in [overview.md](overview.md#naming-and-addressing) --
a `hostnames` map of A records plus an `aliases` map of CNAMEs grouping every service under the host that serves it.
Moving a service between hosts is an edit to `aliases`.

## `docker/nas`

The one place OpenTofu manages a workload rather than a machine, because the TrueNAS box is an appliance and cannot run
NixOS. The Docker provider connects over SSH, which is why `bin/docker.sh` forwards an SSH agent socket -- with
platform-specific handling, since Docker Desktop on macOS exposes it at a fixed path.

Anything that *can* run NixOS should use a quadlet under `src/nix/host/` instead.

## Host Lifecycle

A host spans both trees -- an OpenTofu root here, a `flake.nix` entry and host directory under `src/nix/`, plus DNS
and DHCP records -- and for VMs those records are coupled to the derived MAC described above. Adding, renaming, and
removing a host are procedures rather than architecture, and live in the `create-edit-host` skill.

Two ordering constraints are worth knowing even if you never run them: `network` must be applied *before* a new
machine first boots, or it will not receive its reserved address; and a `destroy` must run *before* the configuration
is deleted, or the VM is orphaned.
