# k8s/app/postgresql

An [Ansible](https://www.ansible.com) role used to install a [PostgreSQL](https://www.postgresql.org/) server.

# Setup

Any accounts referenced by [`initial`](#initial) should be stored on the [Vault](https://www.vaultproject.io) server
under the path `cubbyhole/k8s-cluster/<cluster_name>/accounts/<account_id>` with type
[`account`](../../../../README.md#account).

The database configuration, including [`initial`](#initial) information, should be stored on the Vault server under the
path `cubbyhole/k8s-cluster/<cluster_name>/postgresql/<postgresql_instance_name>` with the following schema in order to
keep sensitive information out of source control:

```json
{
  "admin_password": "<admin password>",
  "initial": {
    "accounts": {
      "<account_id>": {
        "databases": [
          "<database_id>",
          ...
        ]
      },
      ...
    },
    "databases": [
      "<database_id>",
      ...
    ]
  }
}
```

# Usage

Provide a variable named `k8s_app_postgresql_params` of type [`k8s_app_postgresql_params`](#k8s_app_postgresql_params)
when including/depending on this role.

# Types

## `accountinfo`

Information about a database account.

### Schema

```yaml
databases:
```

| Name        | Type       | Required? | Description                                   |
| ----------- | ---------- | --------- | --------------------------------------------- |
| `databases` | `string[]` | no        | A listing of databases owned by this account. |

## `initial`

Information about the initial database items to create.

### Schema

```yaml
accounts:
databases:
```

| Name        | Type                                         | Required? | Description                                                                   |
| ----------- | -------------------------------------------- | --------- | ----------------------------------------------------------------------------- |
| `accounts`  | [`map[string -> accountinfo]`](#accountinfo) | no        | A map defining which accounts to create and the databases those accounts own. |
| `databases` | `string`                                     | no        | A listing of databases to create.                                             |

## `k8s_app_postgresql_params`

The parameters for this role.

### Schema

```yaml
hostname:
initial:
name:
namespace:
password:
size:
volume_info:
```

| Name          | Type                                                                                                   | Required? | Description                                                   |
| ------------- | ------------------------------------------------------------------------------------------------------ | --------- | ------------------------------------------------------------- |
| `hostname`    | `string`                                                                                               | **yes**   | The hostname to use.                                          |
| `initial`     | [`initial`](#initial)                                                                                  | no        | The initial database items to create.                         |
| `name`        | `string`                                                                                               | **yes**   | The name for the installation.                                |
| `namespace`   | `string`                                                                                               | no        | The namespace in which PostgreSQL resources will be deployed. |
| `password`    | `string`                                                                                               | **yes**   | The password to use for the admin user.                       |
| `size`        | `size`                                                                                                 | **yes**   | The amount of storage space to provision.                     |
| `volume_info` | [`volume_source`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#volume-v1-core) | **yes**   | Configuration for the persistent volume that will be used.    |
