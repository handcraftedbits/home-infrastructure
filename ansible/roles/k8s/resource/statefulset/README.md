# k8s/resource/statefulset

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[stateful set](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) resource.

# Usage

Provide a variable named `k8s_resource_statefulset_params` of type
[`k8s_resource_statefulset_params`](#k8s_resource_statefulset_params) when including/depending on this role.

# Types

## `k8s_resource_statefulset_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
namespace:
spec:
```

| Name          | Type                                                                                                           | Required? | Description                                                                                                                |
|---------------|----------------------------------------------------------------------------------------------------------------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`                                                                                                          | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                          | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                       | **yes**   | The name of this stateful set.                                                                                             |
| `namespace`   | `string`                                                                                                       | **yes**   | The namespace for this stateful set.                                                                                       |
| `spec`        | [`statefulset_spec`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#statefulset-v1-apps) | **yes**   | The spec for this stateful set.                                                                                            |
