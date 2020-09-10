# k8s/app/organizr

An [Ansible](https://www.ansible.com) role used to install [organizr](https://organizr.app/).

# Usage

Provide a variable named `k8s_app_organizr_params` of type [`k8s_app_organizr_params`](#k8s_app_organizr_params) when
including/depending on this role.

The organizr server will be available at `https://<hostname>/`.

# Types

## `k8s_app_organizr_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
hostname:
name:
namespace:
replicas:
size:
volume_info:
```

| Name                 | Type                                                                                                   | Required? | Description                                                 |
| -------------------- | ------------------------------------------------------------------------------------------------------ | --------- | ----------------------------------------------------------- |
| `certificate_issuer` | `string`                                                                                               | **yes**   | The name of the certificate issuer to use.                  |
| `hostname`           | `string`                                                                                               | **yes**   | The hostname to use.                                        |
| `name`               | `string`                                                                                               | **yes**   | The name for the installation.                              |
| `namespace`          | `string`                                                                                               | no        | The namespace in which organizr resources will be deployed. |
| `replicas`           | `string`                                                                                               | no        | The number of replicas to deploy.                           |
| `size`               | `size`                                                                                                 | **yes**   | The amount of storage space to provision.                   |
| `volume_info`        | [`volume_source`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#volume-v1-core) | **yes**   | Configuration for the persistent volume that will be used.  |
