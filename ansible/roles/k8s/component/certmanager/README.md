# k8s/component/certmanager

An [Ansible](https://www.ansible.com) role used to enable automatic certificate management via
[cert-manager](https://docs.cert-manager.io/en/latest/).

# Usage

Provide a variable named `k8s_component_certmanager_params` of type
[`k8s_component_certmanager_params`](#k8s_component_certmanager_params) when including/depending on this role.

# Types

## `k8s_component_certmanager_params`

The parameters for this role.

### Schema

```yaml
config:
namespace:
prefix:
```

| Name        | Type                                                                                                 | Required? | Description                                                     |
|-------------|------------------------------------------------------------------------------------------------------|-----------|-----------------------------------------------------------------|
| `config`    | [`certmanager_config`](https://github.com/helm/charts/tree/master/stable/cert-manager#configuration) | **yes**   | The cert-manager configuration to use.                          |
| `namespace` | `string`                                                                                             | **yes**   | The namespace in which cert-manager resources will be deployed. |
| `prefix`    | `string`                                                                                             | **yes**   | The prefix for cert-manager resources.                          |
