# dev/gpg

An [Ansible](https://www.ansible.com) role used to install [GnuPG](https://gnupg.org/) and associated
tooling/configuration.

# Usage

Provide a variable named `dev_gpg_params` of type [`dev_gpg_params`](#dev_gpg_params) when including/depending on this
role.

# Types

## `dev_gpg_params`

The parameters for this role.

### Schema

```yaml
key:
username:
```

| Name       | Type     | Required? | Description                                         |
| ---------- | -------- | --------- | --------------------------------------------------- |
| `key`      | `string` | **yes**   | The public key to use.                              |
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
