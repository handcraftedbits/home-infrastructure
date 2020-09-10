# k8s/resource/namespace

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) resource.

# Usage

Provide a variable named `k8s_resource_namespace_params` of type
[`k8s_resource_namespace_params`](#k8s_resource_namespace_params) when including/depending on this role.

# Types

## `k8s_resource_namespace_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
```

| Name          | Type     | Required? | Description                                                                                                                |
|---------------|----------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`    | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`    | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string` | **yes**   | The name of this namespace.                                                                                                |
