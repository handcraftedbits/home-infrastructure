# k8s/app/openldap

An [Ansible](https://www.ansible.com) role used to install an [OpenLDAP](https://www.openldap.org) server using the
[osixia/openldap](https://github.com/osixia/docker-openldap) [Docker](https://www.docker.com/) image.

# Setup

Any users referenced by [`entries`](#entries) should be stored on the [Vault](https://www.vaultproject.io) server
under the path `cubbyhole/k8s-cluster/<cluster_name>/users/<user_id>` with type [`user`](../../../../README.md#user).

The LDAP configuration, including [`entries`](#entries) information, should be stored on the Vault server under the
path `cubbyhole/k8s-cluster/<cluster_name>/ldap/<ldap_instance_name>` with the following schema in order to keep
sensitive information out of source control:

```json
{
  "admin_password": "<admin password>",
  "domain": "<LDAP domain>",
  "entries": {
    "ous": {
      "groups": "groups",
      "users": "users"
    },
    "users": {
      "<user_id>": {
        "groups": [
          "<group_id>",
          ...
        ]
      },
      ...
    }
  },
  "organization": "<LDAP organization>"
}
```

# Usage

Provide a variable named `k8s_app_openldap_params` of type [`k8s_app_openldap_params`](#k8s_app_openldap_params) when
including/depending on this role.

The OpenLDAP server will be available at `<hostname>:389` or `<hostname>:636`, with an admin user having DN
`cn=admin,dc=<domain_part>,dc=<domain_part>,...` and password `password`.

# Types

## `entries`

Information about the LDAP entries (users and groups) to create.

### Schema

```yaml
ous:
  groups:
  users:
users:
```

| Name         | Type                                     | Required? | Description                                                                              |
| ------------ | ---------------------------------------- | --------- | ---------------------------------------------------------------------------------------- |
| `ous.groups` | `string`                                 | **yes**   | The name (without any prefixes or suffixes) of the OU to use for groups.                 |
| `ous.users`  | `string`                                 | **yes**   | The name (without any prefixes or suffixes) of the OU to use for users.                  |
| `users`      | [`map[string -> ldap_user]`](#ldap_user) | no        | A mapping of user IDs (without any prefixes or suffixes) to additional user information. |

## `k8s_app_openldap_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
domain:
entries:
hostname:
name:
namespace:
password:
replicas:
size:
volume_info:
```

| Name                 | Type                                                                                                   | Required? | Description                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------ | --------- | ----------------------------------------------------------- |
| `certificate_issuer` | `string`                                                                                               | **yes**   | The name of the certificate issuer to use.                  |
| `domain`             | `string`                                                                                               | **yes**   | The LDAP domain to use.                                     |
| `entries`            | [`entries`](#entries)                                                                                  | no        | The LDAP entries (users and groups) to create.              |
| `hostname`           | `string`                                                                                               | **yes**   | The hostname to use.                                        |
| `name`               | `string`                                                                                               | **yes**   | The name for the installation.                              |
| `namespace`          | `string`                                                                                               | no        | The namespace in which OpenLDAP resources will be deployed. |
| `password`           | `string`                                                                                               | **yes**   | The password to use for the admin user.                     |
| `replicas`           | `string`                                                                                               | no        | The number of replicas to deploy.                           |
| `size`               | `size`                                                                                                 | **yes**   | The amount of storage space to provision.                   |
| `volume_info`        | [`volume_source`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#volume-v1-core) | **yes**   | Configuration for the persistent volume that will be used.  |

## `ldap_user`

Information about a single LDAP user.

### Schema

```yaml
groups:
```

| Name     | Type       | Required? | Description                                                                           |
| -------- | ---------- | --------- | ------------------------------------------------------------------------------------- |
| `groups` | `string[]` | no        | A list of groups (without any prefixes or suffixes) that the user should be added to. |
