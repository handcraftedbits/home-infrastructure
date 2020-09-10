# k8s/component/nginx

An [Ansible](https://www.ansible.com) role used to create an
[NGiNX ingress](https://kubernetes.github.io/ingress-nginx).

# Usage

Provide a variable named `k8s_component_nginx_params` of type
[`k8s_component_nginx_params`](#k8s_component_nginx_params) when including/depending on this role.

# Types

## `k8s_component_nginx_params`

The parameters for this role.

### Schema

```yaml
config:
namespace:
prefix:
```

| Name        | Type                                                                                     | Required? | Description                                                      |
|-------------|------------------------------------------------------------------------------------------|-----------|------------------------------------------------------------------|
| `config`    | [`nginx_config`](https://github.com/helm/charts/tree/stable/nginx-ingress#configuration) | **yes**   | The nginx-ingress configuration to use.                          |
| `namespace` | `string`                                                                                 | **yes**   | The namespace in which nginx-ingress resources will be deployed. |
| `prefix`    | `string`                                                                                 | **yes**   | The prefix for nginx-ingress resources.                          |
