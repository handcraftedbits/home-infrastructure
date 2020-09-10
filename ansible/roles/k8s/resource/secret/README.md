# k8s/resource/secret

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[secret](https://kubernetes.io/docs/concepts/configuration/secret/) resource.

# Usage

Provide a variable named `k8s_resource_secret_params` of type
[`k8s_resource_secret_params`](#k8s_resource_secret_params) when including/depending on this role.

# Types

## `k8s_resource_secret_params`

The parameters for this role.

### Schema

```yaml
annotations:
key:
labels:
name:
namespace:
value:
```

| Name          | Type     | Required? | Description                                                                                                                |
|---------------|----------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`    | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `key`         | `string` | **yes**   | The key for the secret value.                                                                                              |
| `labels`      | `map`    | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string` | **yes**   | The name of this secret.                                                                                                   |
| `namespace`   | `string` | **yes**   | The namespace for this secret.                                                                                             |
| `value`       | `string` | **yes**   | The secret value.                                                                                                          |
