# k8s/component/externaldns

An [Ansible](https://www.ansible.com) role used to enable automatic external DNS updates via
[external-dns](https://github.com/kubernetes-incubator/external-dns).

# Usage

Provide a variable named `k8s_component_externaldns_params` of type
[`k8s_component_externaldns_params`](#k8s_component_externaldns_params) when including/depending on this role.

# Types

## `k8s_component_externaldns_params`

The parameters for this role.

### Schema

```yaml
address_pool_name:
domain:
domain_reverse:
namespace:
prefix:
replicas:
```

| Name                | Type     | Required? | Description                                                                                                            |
|---------------------|----------|-----------|------------------------------------------------------------------------------------------------------------------------|
| `address_pool_name` | `string` | **yes**   | The name of the MetalLB address pool to be used for DNS services.                                                      |
| `domain`            | `string` | **yes**   | The domain name this DNS server will provide information for.                                                          |
| `domain_reverse`    | `string` | **yes**   | The [reverse DNS name](https://en.wikipedia.org/wiki/Reverse_DNS_lookup) this DNS server will use for reverse lookups. |
| `namespace`         | `string` | **yes**   | The namespace in which external-dns resources will be deployed.                                                        |
| `prefix`            | `string` | **yes**   | The prefix for external-dns resources.                                                                                 |
| `replicas`          | `string` | no        | The number of replicas to deploy.                                                                                      |
