# k8s/app/pgadmin

An [Ansible](https://www.ansible.com) role used to install [pgAdmin](https://www.pgadmin.org/).

# Usage

Provide a variable named `k8s_app_pgadmin_params` of type [`k8s_app_pgadmin_params`](#k8s_app_pgadmin_params) when
including/depending on this role.

The pgadmin server will be available at `https://<hostname>/`.

# Types

## `admin_info`

Information about the default pgAdmin admin user.

### Schema

```yaml
email:
password:
```

| Name       | Type     | Required? | Description                     |
| ---------- | -------- | --------- | ------------------------------- |
| `email`    | `string` | **yes**   | The admin user's email address. |
| `password` | `string` | **yes**   | The admin user's password.      |

## `k8s_app_pgadmin_params`

The parameters for this role.

### Schema

```yaml
admin:
certificate_issuer:
cluster_domain:
dns_server:
hostname:
name:
namespace:
replicas:
size:
volume_info:
```

| Name                 | Type                                                                                                   | Required? | Description                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------ | --------- | ---------------------------------------------------------------------------- |
| `admin`              | [`admin_info`](#admin_info)                                                                            | **yes**   | Information about the default pgAdmin admin user.                            |
| `certificate_issuer` | `string`                                                                                               | **yes**   | The name of the certificate issuer to use.                                   |
| `cluster_domain`     | `string`                                                                                               | **yes**   | The domain suffix of the Kubernetes cluster where this resource is deployed. |
| `dns_server`         | `string`                                                                                               | no        | Alternate DNS server information (only used if defaults don't work).         |
| `hostname`           | `string`                                                                                               | **yes**   | The hostname to use.                                                         |
| `name`               | `string`                                                                                               | **yes**   | The name for the installation.                                               |
| `namespace`          | `string`                                                                                               | no        | The namespace in which pgAdmin resources will be deployed.                   |
| `replicas`           | `string`                                                                                               | no        | The number of replicas to deploy.                                            |
| `size`               | `size`                                                                                                 | **yes**   | The amount of storage space to provision.                                    |
| `volume_info`        | [`volume_source`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#volume-v1-core) | **yes**   | Configuration for the persistent volume that will be used.                   |
