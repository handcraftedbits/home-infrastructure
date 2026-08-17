---
name: create-edit-quadlet
description: >
  Adding, editing, or removing a containerized service on a Linux host in this repository. Services run as rootless
  podman quadlets generated from Nix, not as NixOS service modules or Docker Compose. Use this skill whenever the user
  asks to run a new container, expose a service through Traefik, give a container a GPU, wire up a dependency on a
  database or another host, pass a secret into a container, or disable/remove a service. Triggers on mentions of
  `*.container.nix`, `*.environment.nix`, `*.network.nix`, `mkUserQuadlets`, `mkTcpAvailabilityService`,
  `mkGpuAvailabilityService`, quadlets, podman, `AutoUpdate`, `EnvironmentFile`, Traefik labels, or any path under a
  host's `container/` directory.
---

# Quadlet Authoring Skill

Containerized services on Linux hosts are **rootless podman quadlets**, rendered from Nix strings into
`~/.config/containers/systemd/` for the main user. They are not NixOS service modules, not
`virtualisation.oci-containers`, and not Compose. Each service is a directory; creating that directory and adding one
line to the host registers it.

See [../../docs/architecture/nix.md](../../docs/architecture/nix.md) for why the design is shaped this way; this skill
is the procedure and the conventions.

## Layout and Naming

```
src/nix/host/<type>/<host>/container/<service>/
  <service>.container.nix      <- required; the quadlet unit, as a Nix string
  <service>.environment.nix    <- optional; env file contents, may reference secrets
  <service>.network.nix        <- optional; other quadlet types work the same way
  config/                      <- optional; whole directory linked to ~/.config/<service>
  data/                        <- optional; whole directory linked to ~/.local/share/<service>
```

The directory name is the service name and must match the file prefixes. It is also what `config/` and `data/` are named
after on disk, so renaming the directory moves those mounts.

The file extension determines the generated systemd unit, via `mkUnitName` in `mkUserQuadlets.nix`:

| File                    | Generated unit             |
|-------------------------|----------------------------|
| `<name>.container.nix`  | `<name>.service`           |
| `<name>.kube.nix`       | `<name>.service`           |
| `<name>.network.nix`    | `<name>-network.service`   |
| `<name>.pod.nix`        | `<name>-pod.service`       |
| `<name>.volume.nix`     | `<name>-volume.service`    |

This matters when writing dependencies: a `Requires=` on the Traefik network is `traefik-network.service`, **not**
`traefik.network`. Only `.container.nix` and `.network.nix` are currently used in this repository.

## Registration

Add one line to the host's `configuration.nix`, inside `util.mkUserQuadlets`:

```nix
{ directory = ./container/newservice; }
```

Keep the list alphabetical. To keep a definition without running it:

```nix
{
  directory = ./container/immich-server;
  enabled = false;
}
```

There is no other registration step -- the directory is scanned with `readDir`.

## Ordering Rules

Two conventions hold across all container files with no exceptions. Follow them exactly.

**Sections are alphabetical**, not in systemd's conventional order. `[Unit]` goes last:

```
[Container]
[Install]
[Service]
[Unit]
```

**Keys within a section are alphabetical.** Repeated keys (`Label=`, `Volume=`, `After=`, `PublishPort=`) sort as a
group and are alphabetical among themselves. In `[Unit]` this means all `After=` lines, then `BindsTo=`, then
`Description=`, then `Requires=`, then `Wants=`.

## The Container File

The Nix signature is `{ ... }:` unless the file interpolates `vars`, in which case it is `{ vars, ... }:`. The body is a
single `''` string.

A typical service:

```nix
{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=newservice
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/vendor/newservice:latest
Label=traefik.enable=true
Label=traefik.http.routers.newservice.entrypoints=websecure
Label=traefik.http.routers.newservice.rule=Host(`newservice.app.howard.estate`)
Label=traefik.http.routers.newservice.tls.certresolver=route53
Label=traefik.http.services.newservice.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/newservice:/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=New Service
Wants=traefik.service
''
```

`[Install] WantedBy=default.target` and `[Service] Restart=always` / `TimeoutStartSec=900` are near-universal; keep them
unless there is a reason not to. `AutoUpdate=registry` is standard for images tracked by tag.

### Systemd Specifiers

Use these rather than hardcoding paths:

| Specifier | Expands to                            | Typical use                          |
|-----------|---------------------------------------|--------------------------------------|
| `%h`      | The user's home directory             | `Volume=%h/.config/<service>:...`    |
| `%N`      | The unit name, without suffix         | `EnvironmentFile=.../environment/%N` |
| `%t`      | The runtime directory (`/run/user/N`) | `Volume=%t/podman/podman.sock:...`   |
| `%U`      | The user's UID                        | `Environment=USER_UID=%U`            |
| `%G`      | The user's GID                        | `Environment=USER_GID=%G`            |

`EnvironmentFile=%h/.config/containers/environment/%N` is the idiomatic line -- `%N` makes it match the unit
automatically, so it never has to be edited when a service is renamed.

### Volumes

Three host-path shapes are in use:

* `/mnt/container/<service>/...` -- persistent state on the NAS. Requires `After=mnt-container.mount`.
* `%h/.config/<service>` or `%h/.local/share/<service>` -- content shipped from `config/` or `data/`. Mount `:ro`.
* `%t/podman/podman.sock` -- the podman socket, for containers that inspect podman (Traefik). See below.

`UserNS=keep-id` maps the container user to the host user and is needed whenever a container writes to a bind mount it
must own. Eleven services use it; add it if a container hits permission errors on `/mnt/container`.

## Secrets and the Environment File

`<service>.environment.nix` becomes the env file. It takes `{ vars, ... }:` when it references anything from `vars`:

```nix
{ vars, ... }:
''
POSTGRES_PASSWORD=$(cat ${vars.postgresql.password})
POSTGRES_USER=postgres
TZ=${vars.timeZone}
''
```

Two different interpolations are at work, and confusing them is the main hazard:

* `${vars.timeZone}` is **Nix** interpolation. It substitutes a literal value at build time and is fine for non-secret
  config.
* `$(cat ${vars.postgresql.password})` is **shell** command substitution. Nix substitutes only the *path*; the
  `$(cat ...)` is executed later by the activation script, which writes the resulting plaintext into the env file at
  mode 600.

The second form is what keeps secrets out of the Nix store -- the store holds `$(cat /run/agenix/...)`, never the value.
**Always use `$(cat ${vars.<path>})` for a secret; never `builtins.readFile`.**

Because the activation script writes the file with `echo "..."`, a literal `$`, backtick, or backslash in a value would
be interpreted by the shell. No current env file needs one; if a password contains such a character, that is a real
problem to raise rather than work around silently.

Secret paths come from the filename under `src/nix/module/secret/`: `secret/postgresql/password.age` is
`vars.postgresql.password`. Adding the `.age` file is all that is needed to make the path exist.

## Config and Data Directories

A `config/` directory beside the quadlet is linked wholesale to `~/.config/<service>`; `data/` goes to
`~/.local/share/<service>`. Mount them read-only:

```
Volume=%h/.config/glance:/app/config:ro
Volume=%h/.local/share/glance/icons:/app/assets/icons:ro
```

Use these for content that belongs in version control -- a `settings.yml`, a set of icons, a Traefik dynamic config. Use
`/mnt/container/<service>` for anything the container writes.

## Waiting on Things

This is the part most often gotten wrong. Pick the mechanism by *what* is being waited on:

| Waiting on                        | How                                                                             |
|-----------------------------------|---------------------------------------------------------------------------------|
| A NAS mount                       | `After=mnt-container.mount` (or `mnt-media.mount`)                              |
| Another container, same host      | `After=<other>.service`, plus `BindsTo=` if it must not outlive it              |
| A service on **another host**     | `mkTcpAvailabilityService` in `configuration.nix`, then `Wants=`/`After=` it    |
| An NVIDIA GPU                     | `mkGpuAvailabilityService`, plus `AddDevice=`                                   |
| The podman socket                 | `BindsTo=podman.socket` and `After=podman.socket`                               |
| The Traefik network               | `Requires=traefik-network.service` and `After=traefik-network.service`          |

Systemd semantics, since the four keys are not interchangeable:

* `After=` -- ordering only. Does **not** start the other unit.
* `Wants=` -- pulls the other unit in, but tolerates its failure. Pair with `After=`.
* `Requires=` -- hard dependency; this unit fails if the other does.
* `BindsTo=` -- strongest; this unit stops whenever the other stops.

### Cross-Host Dependencies

A quadlet cannot express "start after PostgreSQL on `datahost` is up". Declare an availability service in the host's
`configuration.nix`:

```nix
(util.mkTcpAvailabilityService {
  name = "postgresql-available";
  host = "postgresql.db.howard.estate";
  port = 5432;
})
```

Then depend on it by unit name:

```
After=postgresql-available.service
Wants=postgresql-available.service
```

The unit polls the port, signals readiness once, and then **exits non-zero when the port stops answering**. With
`Restart=always` it re-enters the waiting state, which tears down and retries everything bound to it. That is how a
database restart on one host propagates to consumers on another.

Always address the remote service by its **role alias** (`postgresql.db.howard.estate`, `llm.howard.estate`),
never by machine name or IP, so the dependency survives the service moving hosts.

### GPUs

Declare one availability service per GPU index in `configuration.nix`:

```nix
(util.mkGpuAvailabilityService { index = 0; })
```

Then in the quadlet, both request the device and wait for it:

```
AddDevice=nvidia.com/gpu=0

[Unit]
After=nvidia-gpu-0-available.service
Wants=nvidia-gpu-0-available.service
```

The availability unit blocks until `/dev/nvidia<N>`, `/dev/nvidia-modeset`, and the persistenced socket all exist, which
they do not at the moment podman would otherwise start. The host also needs `../../../module/hardware/nvidia.nix`
imported -- only `aihost` has it today.

## Traefik Exposure

To put a service behind HTTPS, join the Traefik network and add labels. The router and service names should match the
container name:

```
Label=traefik.enable=true
Label=traefik.http.routers.<name>.entrypoints=websecure
Label=traefik.http.routers.<name>.rule=Host(`<alias>.howard.estate`)
Label=traefik.http.routers.<name>.tls.certresolver=route53
Label=traefik.http.services.<name>.loadbalancer.server.port=<container port>
Network=traefik.network
```

The port is the port **inside** the container; do not add `PublishPort=` as well. Reserve `PublishPort=` for traffic
that does not go through Traefik at all, such as AdGuard's port 53.

Certificates resolve through the `route53` DNS challenge, so the hostname must be a real record. **Add the alias to the
`aliases` map in `src/opentofu/network/dns.tofu` under the serving host**, and tell the user to apply `bin/network.sh`.
A quadlet whose `Host()` rule has no DNS entry will fail certificate issuance.

For raw TCP, use `traefik.tcp.routers.*` with `HostSNI` and a matching entrypoint, as Forgejo does for SSH on 2222.

## Removing or Renaming

`mkUserQuadlets` reconciles running units against a hash manifest on every activation, so a removed quadlet is stopped
and a renamed one is stopped-then-started under the new name. Nothing needs stopping by hand.

To **remove**: delete the directory and its line in `configuration.nix`. Remove any `mkTcpAvailabilityService` that
existed only for it, any `After=`/`Wants=` other quadlets had on it, and its `aliases` entry in `dns.tofu`.

To **rename**: rename the directory and all `<service>.*.nix` files together, update `ContainerName=`, the Traefik
router/service label names, the registration line, and every other quadlet that referenced the old unit name. The
`EnvironmentFile=...%N` line needs no change, which is the point of using `%N`.

Prefer `enabled = false` over deletion when the user may want the service back.

## Rules

* **Never run a rebuild**, `systemctl`, or `podman`. Make the edits and report what will change on the next rebuild.
* Sections and keys are alphabetical; `[Unit]` comes last.
* Secrets use `$(cat ${vars.<path>})` in an `.environment.nix`, never anywhere else.
* Cross-host references use role aliases, never machine names.

## Checklist

* Directory name, file prefixes, and `ContainerName=` all agree.
* Registered in the host's `mkUserQuadlets` list, alphabetically.
* Sections ordered `[Container]`, `[Install]`, `[Service]`, `[Unit]`; keys alphabetical within each.
* `EnvironmentFile` uses `%N`, not a hardcoded name.
* Every `/mnt/container` volume is paired with `After=mnt-container.mount`.
* Every cross-host dependency has a `mkTcpAvailabilityService` in `configuration.nix` **and** a `Wants=`/`After=`.
* A GPU container has both `AddDevice=` and the matching `nvidia-gpu-<N>-available.service` dependency.
* Traefik-exposed services have a DNS alias in `dns.tofu`, and `network.sh` was flagged to run.
* Secrets are `$(cat ...)`, and the `.environment.nix` takes `{ vars, ... }:`.
