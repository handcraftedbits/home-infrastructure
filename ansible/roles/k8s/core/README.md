# k8s/core

An [Ansible](https://www.ansible.com) role used to set up core pieces of a basic [Kubernetes](https://kubernetes.io)
cluster (dynamic DNS, certificate issuing, load balancing, etc.).

# Usage

Provide a variable named `k8s_core_params` of type [`k8s_core_params`](#k8s_core_params) when including/depending on
this role.

# Types

## `dns_config`

Settings for external DNS.

### Schema

```yaml
address_pool_name:
domain:
domain_reverse:
```

| Name                | Type     | Required? | Description                                                                                                                    |
| ------------------- | -------- | --------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `address_pool_name` | `string` | no        | The name of the address pool to be used for DNS services.                                                                      |
| `domain`            | `string` | **yes**   | The domain name by which the cluster is externally-accessible.                                                                 |
| `domain_reverse`    | `string` | **yes**   | The [reverse DNS name](https://en.wikipedia.org/wiki/Reverse_DNS_lookup) the external DNS server will use for reverse lookups. |

## `k8s_core_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
certificate_manager:
dns:
ingress:
load_balancer:
namespace:
nfs:
```

| Name                  | Type                                                                                                 | Required? | Description                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- | --------- | ---------------------------------------------------- |
| `certificate_issuer`  | [`clusterissuer_params[]`](../resource/clusterissuer/README.md#k8s_resource_clusterissuer_params)    | **yes**   | The certificate issuer configuration to use.         |
| `certificate_manager` | [`certmanager_config`](https://github.com/helm/charts/tree/master/stable/cert-manager#configuration) | **yes**   | The certificate manager configuration to use.        |
| `dns`                 | [`dns_config`](#dns_config)                                                                          | **yes**   | The external DNS configuration to use.               |
| `ingress`             | [`nginx_config`](https://github.com/helm/charts/tree/stable/nginx-ingress#configuration)             | **yes**   | The ingress configuration to use.                    |
| `load_balancer`       | [`metallb_config`](https://metallb.universe.tf/configuration/)                                       | **yes**   | The load balancer configuration to use.              |
| `namespace`           | `string`                                                                                             | no        | The namespace in which core components are deployed. |
| `nfs`                 | [`nfsprovisioner_params`](../component/nfsprovisioner/README.md#k8s_component_nfsprovisioner_params) | no        | The NFS provisioner configuration to use.            |
