# k8s/component/metallb

An [Ansible](https://www.ansible.com) role used to create a [MetalLB](https://metallb.universe.tf) load balancer.

# Usage

Provide a variable named `k8s_component_metallb_params` of type
[`k8s_component_metallb_params`](#k8s_component_metallb_params) when including/depending on this role.

# Types

## `k8s_component_metallb_params`

The parameters for this role.

### Schema

```yaml
config:
namespace:
prefix:
```

| Name        | Type                                                           | Required? | Description                                                |
|-------------|----------------------------------------------------------------|-----------|------------------------------------------------------------|
| `config`    | [`metallb_config`](https://metallb.universe.tf/configuration/) | **yes**   | The MetalLB configuration to use.                          |
| `namespace` | `string`                                                       | **yes**   | The namespace in which MetalLB resources will be deployed. |
| `prefix`    | `string`                                                       | **yes**   | The prefix for MetalLB resources.                          |
