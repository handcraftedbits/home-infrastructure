# Container Images (`src/docker/`)

Two images, one deriving from the other. They exist so the toolchain is pinned in a `Dockerfile` rather than assumed to
be present on whichever machine is running the command.

## Layout Convention

Each image directory holds a `src/` subtree that *is* the build context, with the `Dockerfile` at
`src/docker/Dockerfile`:

```
src/docker/<image>/
  src/
    docker/Dockerfile
    <everything copied into the image>
```

`build_image_if_necessary` in `bin/common.sh` relies on this shape -- it builds with `-f <dir>/src/docker/Dockerfile`
and context `<dir>/src`. A new image must follow it.

## `infrastructure-runner`

The base image and the one that does nearly all the work. Ubuntu plus `age`, `busybox`, `docker-ce-cli`, `jq`,
`openssh-client`, `psmisc`, `tofu`, and `govc`.

Its `ENTRYPOINT` is `bin/entrypoint.sh`, which turns an encrypted blob into a working OpenTofu invocation:

1. Decrypt `/opt/container/secrets.age` with the mounted age key.
2. Write `~/.aws/config` and `~/.aws/credentials` from the `aws` key in the decrypted JSON, so the S3 state backend and
   the AWS provider authenticate without any credentials in the environment.
3. Strip the `aws` key -- plus anything named by `--secrets-to-delete` -- and write the rest as a `tfvars.json`. The
   same filtering is applied to `src/template/constants.tfvars.json` via `--constants-to-delete`.
4. Exec `tofu`, injecting both var files for the subcommands that accept them (`apply`, `destroy`, `import`, `plan`,
   `refresh`) and passing anything else through untouched.

The stripping step exists because OpenTofu errors on undeclared variables, and each root module declares only what it
uses. See [bin.md](bin.md#per-script-secret-filtering).

`constants.tfvars.json` holds the non-secret bootstrap constants -- the flake's Git URL, its anonymous HTTPS equivalent,
and the path to `flake.nix` within the repository. It is baked into the image rather than mounted, so a change to it
forces a rebuild.

### Helper Scripts

Invoked by OpenTofu `local-exec` provisioners, not by users:

* `bin/nixos/build-iso.sh` -- builds an unattended NixOS installer ISO by running
  `ghcr.io/handcraftedbits/nixos-unattended-iso-builder` (hence the mounted Docker socket), skipping the build if a
  cached ISO with the same name already exists. The filename encodes the bootstrap URL, so a different URL yields a
  different ISO.
* `bin/nixos/start-host.sh` -- writes `bootstrap.json` (age key, disk, flake URL and path, target hostname) into a temp
  directory and serves it with `busybox httpd`. Runs in the foreground for physical hosts, where the operator waits, and
  in the background for VMs, where OpenTofu continues. The key is redacted in the log echo.
* `bin/nixos/stop-host.sh` -- kills the HTTP server after the VM has installed.
* `bin/remove-cdrom-and-add-pci-devices.sh` -- powers a freshly built VM off, removes the installer CD-ROM, attaches PCI
  devices with `govc`, and powers it back on. PCI passthrough is done here rather than in the
  `vsphere_virtual_machine` resource because the provider cannot reference the VM's own ID during provisioning.

## `physical-host`

`FROM infrastructure-runner`, adding only a wrapper entrypoint. Bare-metal installs need no OpenTofu -- there is nothing
to provision -- so the image exists purely to serve `bootstrap.json` to a machine booting the installer ISO.
`start-physical-host.sh` reads the flake constants with `jq`, maps positional arguments to the `START_HOST_*`
environment variables, and delegates to the inherited `start-host.sh`.

## Adding an Image

Create `src/docker/<name>/src/docker/Dockerfile`, then call `build_image_if_necessary <name>` from the entry point that
needs it. There is no image registry and no build step to wire up; the mtime check handles it.
