# dev/cifs_client

An [Ansible](https://www.ansible.com) role used to mount CIFS shares.

# Setup

CIFS server-to-share mappings should be stored on the [Vault](https://www.vaultproject.io) server under the path
`cubbyhole/dev/shares` in the following format:

```json
{
  "cifs": {
    "<CIFS server hostname>": [
      {
        "account": "<account name>",
        "name": "<CIFS share name>",
        "path": "<local mount path>"
      },
      ...
    ]
  }
}
```

# Usage

Provide a variable named `dev_cifs_client_params` of type [`dev_cifs_client_params`](#dev_cifs_client_params) when
including/depending on this role.

# Types

## `cifs_share`

Information about a single CIFS share.

### Schema

```yaml
account:
name:
path:
```

| Name      | Type     | Required? | Description                                                                                                     |
|-----------|----------|-----------|-----------------------------------------------------------------------------------------------------------------|
| `account` | `string` | **yes**   | The name of the account that will access the CIFS share.  Must be defined in `dev_cifs_client_params.accounts`. |
| `name`    | `string` | **yes**   | The name of the CIFS share to mount.                                                                            |
| `path`    | `string` | **yes**   | The local path where the CIFS share will be mounted.                                                            |

## `dev_cifs_client_params`

The parameters for this role.

### Schema

```yaml
accounts:
shares:
username:
```

| Name       | Type                                                   | Required? | Description                                               |
|------------|--------------------------------------------------------|-----------|-----------------------------------------------------------|
| `accounts` | [`map[string -> account]`](../../../README.md#account) | **yes**   | A mapping of account IDs to CIFS account information.     |
| `shares`   | [`map[string -> cifs_share[]]`](#cifs_share)           | no        | A map of CIFS server hostnames to an array of its shares. |
| `username` | `string`                                               | **yes**   | The name of the OS user for whom this role applies.       |

