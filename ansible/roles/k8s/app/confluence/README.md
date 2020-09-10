# k8s/app/confluence

An [Ansible](https://www.ansible.com) role used to install a [Confluence](https://www.atlassian.com/software/confluence)
server.

# Setup

* Configure [`k8s/app/postgresql`](../postgresql/README.md) to include a database and database owner for the
  application.
* Configure [`k8s/app/openldap`](../openldap/README.md) to include `confluence-administrators` and `confluence-users`
  groups, assigning membership to users as desired.

# Usage

Provide a variable named `k8s_app_confluence_params` of type [`k8s_app_confluence_params`](#k8s_app_confluence_params)
when including/depending on this role.

The Confluence server will be available at `https://<hostname>/`.

# Types

## `database_config`

Database configuration.

### Schema

```yaml
host:
port:
```

| Name   | Type      | Required? | Description                          |
| ------ | --------- | --------- | ------------------------------------ |
| `host` | `string`  | **yes**   | The hostname of the database to use. |
| `port` | `integer` | **yes**   | The port of the database to use.     |

## `k8s_app_confluence_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
cluster_domain:
hostname:
name:
namespace:
replicas:
size:
volume_info:
```

| Name                 | Type                                                                                                   | Required?           | Description                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------ | ------------------- | ---------------------------------------------------------------------------- |
| `certificate_issuer` | `string`                                                                                               | **yes**             | The name of the certificate issuer to use.                                   |
| `cluster_domain`     | `string`                                                                                               | **yes**             | The domain suffix of the Kubernetes cluster where this resource is deployed. |
| `database`           |                                                                                                        | [`database_config`] | **yes**                                                                      | Configuration for the database that will be used. |
| `hostname`           | `string`                                                                                               | **yes**             | The hostname to use.                                                         |
| `name`               | `string`                                                                                               | **yes**             | The name for the installation.                                               |
| `namespace`          | `string`                                                                                               | no                  | The namespace in which Confluence resources will be deployed.                |
| `replicas`           | `string`                                                                                               | no                  | The number of replicas to deploy.                                            |
| `size`               | `size`                                                                                                 | **yes**             | The amount of storage space to provision.                                    |
| `volume_info`        | [`volume_source`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#volume-v1-core) | **yes**             | Configuration for the persistent volume that will be used.                   |
