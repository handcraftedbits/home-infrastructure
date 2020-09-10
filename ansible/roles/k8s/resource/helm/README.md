# k8s/resource/helm

An [Ansible](https://www.ansible.com) role used to deploy a [Helm](https://helm.sh) chart.

# Usage

Provide a variable named `k8s_resource_helm_params` of type [`k8s_resource_helm_params`](#k8s_resource_helm_params) when
including/depending on this role.

# Types

## `helm_repository`

Information for a Helm repository.

### Schema

```yaml
name:
url:
```

| Name   | Type     | Required? | Description                 |
|--------|----------|-----------|-----------------------------|
| `name` | `string` | **yes**   | The name of the repository. |
| `url`  | `string` | **yes**   | The repository URL.         |

## `k8s_resource_helm_params`

The parameters for this role.

### Schema

```yaml
chart:
chart_values:
namespace:
release:
repository:
```

| Name           | Type                                  | Required? | Description                                                                                                                           |
|----------------|---------------------------------------|-----------|---------------------------------------------------------------------------------------------------------------------------------------|
| `chart`        | `string`                              | **yes**   | The Helm chart to deploy.                                                                                                             |
| `chart_values` | `map`                                 | no        | The configuration values to use during deploy.                                                                                        |
| `namespace`    | `string`                              | **yes**   | The namespace where the chart will be deployed.                                                                                       |
| `release`      | `string`                              | **yes**   | The name of the release to create.                                                                                                    |
| `repository`   | [`helm_repository`](#helm_repository) | no        | The Helm repository to use.  Note that the [standard](https://kubernetes-charts.storage.googleapis.com) repository is always enabled. |
