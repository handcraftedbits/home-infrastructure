# dev/gpg

An [Ansible](https://www.ansible.com) role used to install [GnuPG](https://gnupg.org/) and associated
tooling/configuration.

# Setup

The GPG private key should be stored on the [Vault](https://www.vaultproject.io) server under the path
`cubbyhole/dev/gpg` in the following format:

```json
{
  "master": "<GPG private key>"
}
```

# Usage

Provide a variable named `dev_gpg_params` of type [`dev_gpg_params`](#dev_gpg_params) when including/depending on this
role.

# Types

## `dev_gpg_params`

The parameters for this role.

### Schema

```yaml
private_key:
public_key:
username:
```

| Name          | Type     | Required? | Description                                         |
| ------------- | -------- | --------- | --------------------------------------------------- |
| `private_key` | `string` | **yes**   | The private key to use.                             |
| `public_key`  | `string` | **yes**   | The public key to use.                              |
| `username`    | `string` | **yes**   | The name of the OS user for whom this role applies. |
