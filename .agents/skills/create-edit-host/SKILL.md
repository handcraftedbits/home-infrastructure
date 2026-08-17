---
name: create-edit-host
description: >
  Adding, renaming, or decommissioning a machine in this repository -- an ESXi VM, a bare-metal NixOS host, a macOS
  workstation, or an AWS EC2 instance. Use this skill whenever the user asks to create a new host, stand up a VM, change
  a hostname, move a host to a different IP, or remove/decommission a machine. Triggers on mentions of `flake.nix` host
  entries, `hostName`/`hostType`, `mkHost`, DHCP reservations, DNS entries, `dhcp.tofu`, `dns.tofu`, a new directory
  under `src/opentofu/vm/` or `src/nix/host/`, or any question about which MAC address a VM will get.
---

# Host Lifecycle Skill

A host is not one thing in one place. It is an OpenTofu root module, a Nix flake entry, a host directory, a DNS record,
and a DHCP reservation, and for ESXi VMs those last two are coupled through a **derived MAC address** that most people
do not expect. Getting a host wrong usually means getting one of these five out of step with the others.

Read [../../docs/architecture/opentofu.md](../../docs/architecture/opentofu.md) and
[../../docs/architecture/nix.md](../../docs/architecture/nix.md) if you need the surrounding design; this skill is the
procedure.

## Which Kind of Host

The `hostType` decides almost everything. Establish it before writing anything.

| Type              | `hostType` | OpenTofu root                  | MAC      | Provisioned by            |
|-------------------|------------|--------------------------------|----------|---------------------------|
| ESXi VM           | `vm`       | `src/opentofu/vm/<name>/`      | Derived  | `bin/vm.sh`               |
| Bare-metal NixOS  | `physical` | none                           | Real NIC | `bin/physical.sh`         |
| macOS workstation | `physical` | none                           | Real NIC | `darwin-rebuild`, by hand |
| AWS EC2           | `aws`      | `src/opentofu/aws/ec2/<name>/` | n/a      | `bin/aws.sh`              |

Two things follow from this table that are easy to miss:

* **Physical and macOS hosts have no OpenTofu root at all.** There is no machine to provision -- the hardware already
  exists. They still need DNS and DHCP entries, using the NIC's real MAC, which the user must supply. You cannot compute
  it.
* **macOS and bare-metal Linux share `hostType = "physical"`** and both live under `src/nix/host/physical/`. They are
  distinguished only by `system` in `flake.nix` (`aarch64-darwin` versus the default `x86_64-linux`) and by which OS
  module their `configuration.nix` imports.

AWS hosts are the odd one out: they get a public Route 53 record from the EC2 module itself and take no part in LAN DNS
or DHCP. Do not add them to `network/`.

## Required Information

Ask for whatever is missing. Guessing a hostname or an IP is worse than a question, because both are baked into a
derived MAC or a firewall reservation that is painful to correct later.

| Information            | Needed for      | If missing                                                     |
|------------------------|-----------------|----------------------------------------------------------------|
| Host name (short)      | All             | Ask; it becomes the directory, flake attribute, and DNS name   |
| Host type              | All             | Ask; see the table above                                       |
| LAN IP address         | vm, physical    | Ask; must be free within `10.0.1.0/24`                         |
| CPU / RAM / disk       | vm              | Ask; there are no sensible defaults for a home lab             |
| Real MAC address       | physical        | Ask; it cannot be derived, only read off the machine           |
| PCI devices            | vm              | Assume none unless stated                                      |
| Service aliases        | All             | Assume none; they can be added later without touching the host |

## The MAC Address Rule

**For ESXi VMs only**, the MAC is not chosen -- it is computed from the fully-qualified hostname in
`src/opentofu/modules/esxi/vm/locals.tofu`: the literal byte `02` (locally administered) followed by the first five
bytes of `md5(hostname)`.

This is what lets `dhcp.tofu` reserve an IP without referencing the VM module at all. It also means **renaming a VM
changes its MAC**, and a stale DHCP reservation will silently hand the renamed machine the wrong address.

Compute it before writing the reservation:

```shell
h=newhost.vm.lan.howard.estate
md5=$(printf '%s' "$h" | md5)   # md5sum | awk '{print $1}' on Linux
echo "02:${md5:0:2}:${md5:2:2}:${md5:4:2}:${md5:6:2}:${md5:8:2}" | tr 'a-z' 'A-Z'
```

Hash the **full** FQDN, not the short name. `apphost.vm.lan.howard.estate` yields `02:AF:BE:11:04:F3`, which is
exactly the reservation in `dhcp.tofu` -- use that as a check that your command is right before trusting it on a new
name.

## Adding a Host

Work in this order. Steps 1--3 are the Nix side and are safe; step 4 touches the firewall and must be applied before
the machine boots, or it will not get its reserved address.

### 1. Nix Host Directory

Create `src/nix/host/<hostType>/<name>/configuration.nix`, copying the closest sibling. Keep it short -- import the
right OS leaf and add only what is specific to this machine:

```nix
{ vars, ... }:
let
  util = import ../../../module/util { inherit vars; };
in
{
  imports = [
    ../../../module/os/linux/internal/vm.nix
    util.mkDefaultMounts
  ];
}
```

Pick the OS leaf by type: `os/linux/internal/vm.nix` for VMs, `os/linux/internal/physical.nix` for bare metal,
`os/macos` for macOS, `os/linux/aws-minimal.nix` for EC2.

### 2. Flake Entry

Add the host to `flake.nix` under `nixosConfigurations` or `darwinConfigurations`, **alphabetically**:

```nix
newhost = mkHost {
  hostName = "newhost";
  hostType = "vm";
  mainUser = "curtiss";
};
```

`hostName` is the short name and must match the directory. Add `system` only when it is not `x86_64-linux`. Put per-host
overrides in `extraVars`, never in `mkHost` itself.

### 3. OpenTofu Root (vm and aws only)

Create `src/opentofu/vm/<name>/` with three files, copying a sibling:

* `main.tofu` -- one module call. `hostname` is the **FQDN** (`<name>.vm.lan.howard.estate`); the module derives the
  short name for the flake attribute itself with `split(".", var.hostname)[0]`.
* `support.tofu` -- backend and providers. Change the state key to `vm/<name>/terraform.tfstate`. **A copied state key
  will collide with the host you copied from and corrupt its state.**
* `variables.tofu` -- a symlink: `ln -s ../common/variables.tofu variables.tofu`. Do not copy the file.

### 4. Network Entries (vm and physical only)

In `src/opentofu/network/dns.tofu`, add the A record to `hostnames`, and add a group under `aliases` if the host will
serve anything. In `src/opentofu/network/dhcp.tofu`, add a reservation pairing that IP with the MAC -- derived for a
VM, supplied by the user for physical hardware.

### 5. Report What Must Be Run

Do not run any of it. Tell the user the order, because it matters:

1. `bin/network.sh -a <key> apply` -- the reservation must exist before the machine first boots.
2. `bin/vm.sh -a <key> -d <name> -p <port> apply` (or `physical.sh` / `aws.sh`).

## Renaming a Host

A rename is a delete and a create wearing a disguise. For a VM it changes the MAC, and the OpenTofu state is keyed by a
name that no longer exists, so **the machine will be destroyed and rebuilt**. Say this to the user before starting; if
the host holds data on a local disk, it is the wrong operation.

Every place the old name appears:

| Location                             | What changes                                  |
|--------------------------------------|-----------------------------------------------|
| `src/nix/flake.nix`                  | Attribute name and `hostName`                 |
| `src/nix/host/<type>/<old>/`         | Directory name                                |
| `src/opentofu/vm/<old>/`             | Directory name                                |
| `src/opentofu/vm/<new>/main.tofu`    | Module label and `hostname` FQDN              |
| `src/opentofu/vm/<new>/support.tofu` | State key                                     |
| `src/opentofu/network/dns.tofu`      | `hostnames` entry, `aliases` group key        |
| `src/opentofu/network/dhcp.tofu`     | Reservation MAC -- **recompute it**           |
| Other hosts' `configuration.nix`     | Any `mkTcpAvailabilityService` pointing at it |

Most consumers will **not** need changes, and that is by design. Services address each other through role aliases
(`postgresql.db.howard.estate`, `llm.howard.estate`), not machine names, so a rename is invisible to them as long
as the alias moves with the service. Only direct machine-FQDN references break. There are few of them; find them with:

```shell
grep -rn '<old>\.' --include='*.nix' --include='*.tofu' --include='*.yml' src/
```

### Renaming Only the Service Alias

If the user wants a service reachable under a different name and does not care which machine serves it, this is not a
host rename at all -- it is an edit to the `aliases` map in `dns.tofu` plus, usually, a Traefik `Host()` rule label in
the quadlet. Confirm which one they mean before touching `flake.nix`.

## Removing a Host

**Order matters, and getting it backwards orphans real infrastructure.** OpenTofu can only destroy what it can still
see; delete the configuration first and the VM keeps running with no way to reach it except the ESXi console.

1. Have the user run `bin/vm.sh -a <key> -d <name> -p <port> destroy` **first**, while the configuration still exists.
2. Delete `src/opentofu/vm/<name>/` and `src/nix/host/<type>/<name>/`.
3. Remove the `flake.nix` entry.
4. Remove the `dns.tofu` `hostnames` entry and any `aliases` group; remove the `dhcp.tofu` reservation. Have the user
   apply `bin/network.sh`.
5. Remove `mkTcpAvailabilityService` entries on other hosts that pointed at it, or they will wait forever and hold their
   dependants down.
6. Note the orphaned S3 state object at `vm/<name>/terraform.tfstate` -- destroying empties it but does not remove it.

`src/opentofu/vm/dbhost/` is what an incomplete removal looks like: the configuration is gone but a stale `.terraform/`
working directory remains. Harmless, but do not treat it as a template for a live host.

Relocating a service off a host before removing it is a quadlet move plus an `aliases` edit, and belongs in a separate
change from the decommission.

## Rules

* **Never run `tofu`, any script in `bin/`, `nix build`, or a rebuild.** These create and destroy real machines. Make
  the edits, then tell the user what to run and in what order.
* Keep `flake.nix` entries, DNS maps, DHCP reservations, and attribute keys **alphabetical**.
* Wrap at 120 columns; use `--` rather than an em dash.
* Never reuse a state key. Never copy `variables.tofu` instead of symlinking it.

## Known Issue: `bin/physical.sh`

`physical.sh` passes `${working_dir}` to the container as the target hostname, but its `getopts` only handles `-a`,
`-p`, and `-h` -- nothing ever assigns `working_dir`. A bare-metal install therefore receives an empty hostname. If a
user is adding a physical host and it fails this way, that is why; the script needs a `-d` flag wired up the way
`vm.sh` does it.

## Checklist

* Host type established, and the OpenTofu root omitted for physical/macOS hosts.
* `hostName` in `flake.nix` matches both directory names.
* State key in `support.tofu` is unique to this host.
* `variables.tofu` is a symlink, not a copy.
* VM MAC recomputed from the **full FQDN**, and verified against a known host.
* DHCP reservation and DNS A record added, and `network.sh` flagged to run **before** first boot.
* For a rename: user warned that the VM is destroyed and rebuilt.
* For a removal: `destroy` flagged to run **before** the configuration is deleted.
