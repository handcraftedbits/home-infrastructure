# Home Infrastructure

Documentation and tools to manage personal home infrastructure.

# Usage

## AWS Hosts

Run `bin/aws.sh -a <age_key> -d <directory>` where:

* `<age_key>` is the location of the [age](https://github.com/filosottile/age) decryption key
* `<directory>` is the name of a directory under [src/nix/host/aws](src/nix/host/aws)

The installation will proceed automatically.

## Physical Hosts

### Linux

Run `bin/physical.sh -a <age_key> -p <port>` where:

* `<age_key>` is the location of the age decryption key
* `<port>` is the port the HTTP server will listen on

An ISO image will be created that can be burned to a USB drive. Boot the system with it and the installation should
proceed automatically by reading bootstrapping information from the HTTP server that has been started on this machine.
Stop the HTTP server when finished.

### MacOS

Make sure age decryption key is available at `/etc/age-key`, preferably readable only by root.

If [Nix](https://nixos.org/) is not already installed:

1. Install Nix: `sh <(curl -L https://nixos.org/nix/install)`
2. Clone this repository to `/opt/config`
3. In an empty directory, build [nix-darwin](https://github.com/nix-darwin/nix-darwin):
   `nix build github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild --extra-experimental-features "nix-command flakes"`
4. Run `sudo ./result/bin/darwin-rebuild switch --flake /opt/config/src/nix#<hostname> --impure` to perform an initial
   installation, where `<hostname>` is one of `macdesk` or `work`.

Run `nix-rebuild` to rebuild the system.

#### Code Signing

nixpkgs signs macOS binaries ad-hoc, which leaves them with no stable identity, so permission grants (Accessibility,
Full Disk Access, etc.) are lost on every rebuild. `mkSignedApp` re-signs the affected applications during activation
using a self-signed certificate that must be created by hand once per machine, before the first rebuild.

1. Open **Keychain Access**
2. **Keychain Access -> Certificate Assistant -> Create a Certificate...**
3. **Name:** `nix-codesign`
4. **Identity Type:** Self Signed Root
5. **Certificate Type:** Code Signing
6. Create, leaving it in the `login` keychain

Certificate Assistant does not mark the certificate as trusted, and `codesign` refuses to use an untrusted identity, so
trust it for code signing:

```shell
security find-certificate -c nix-codesign -p > /tmp/nix-codesign.pem
sudo security add-trusted-cert -d -r trustRoot -p codeSign -k /Library/Keychains/System.keychain /tmp/nix-codesign.pem
```

Verify with `security find-identity -v -p codesigning`, which should now list `nix-codesign` twice -- once for the login
keychain and once for the copy the command above placed in the system keychain. That is expected.

Some applications will still need their permissions granted once in System Settings afterwards, as macOS offers no
supported way to script this. Those grants then persist across rebuilds, though regenerating the certificate invalidates
them.

## Virtual Machine Hosts

Run `bin/vm.sh -a <age_key> -d <directory> -p <port>` where:

* `<age_key>` is the location of the age decryption key
* `<directory>` is the name of a directory under [src/nix/host/vm](src/nix/host/vm)
* `<port>` is the port the HTTP server will listen on

A virtual machine will be created on the [ESXi](https://www.vmware.com/products/cloud-infrastructure/vsphere) defined in
[src/secrets.age](src/secrets.age) and an HTTP server will be started on this machine. The installation should proceed
automatically by reading bootstrapping information from the HTTP server, after which it will be stopped.

## Docker Containers

Run `bin/docker.sh -a <age_key> -d <directory>` where:

* `<age_key>` is the location of the age decryption key
* `<directory>` is the name of a directory under [src/opentofu/docker](src/opentofu/docker)

Docker containers will be deployed to the host defined in the provided configuration.

## Network Configuration

Run `bin/network.sh -a <age_key>` where:

* `<age_key>` is the location of the age decryption key

Network configuration will be applied to the firewall defined in the provided configuration.
