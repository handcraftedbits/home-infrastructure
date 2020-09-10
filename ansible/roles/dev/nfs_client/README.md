# dev/nfs_client

An [Ansible](https://www.ansible.com) role used to mount NFS shares.

# Setup

NFS server-to-share mappings should be stored on the [Vault](https://www.vaultproject.io) server under the path
`cubbyhole/dev/shares` in the following format:

```json
{
  "nfs": {
    "<NFS server hostname>": [
      {
        "name": "<NFS share name>",
        "path": "<local mount path>"
      },
      ...
    ]
  }
}
```

# Usage

Provide a variable named `dev_nfs_client_params` of type [`dev_nfs_client_params`](#dev_nfs_client_params) when
including/depending on this role.

# Types

## `nfs_share`

Information about a single NFS share.

### Schema

```yaml
name:
path:
```

| Name      | Type     | Required? | Description                                                                                                     |
|-----------|----------|-----------|-----------------------------------------------------------------------------------------------------------------|
| `name`    | `string` | **yes**   | The name of the CIFS share to mount.                                                                            |
| `path`    | `string` | **yes**   | The local path where the CIFS share will be mounted.                                                            |

## `dev_nfs_client_params`

The parameters for this role.

### Schema

```yaml
shares:
username:
```

| Name       | Type                                       | Required? | Description                                              |
|------------|--------------------------------------------|-----------|----------------------------------------------------------|
| `shares`   | [`map[string -> nfs_share[]]`](#nfs_share) | no        | A map of NFS server hostnames to an array of its shares. |
| `username` | `string`                                   | **yes**   | The name of the OS user for whom this role applies.      |
