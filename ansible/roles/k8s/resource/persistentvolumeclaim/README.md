# k8s/resource/persistentvolumeclaim

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[persistent volume claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
resource.

# Usage

Provide a variable named `k8s_resource_persistentvolumeclaim_params` of type
[`k8s_resource_persistentvolumeclaim_params`](#k8s_resource_persistentvolumeclaim_params) when including/depending on
this role.

# Types

## `k8s_resource_persistentvolumeclaim_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
namespace:
spec:
```

| Name          | Type                                                                                                                                   | Required? | Description                                                                                                                |
| ------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------- |
| `annotations` | `map`                                                                                                                                  | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                                                  | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                                               | **yes**   | The name of this persistent volume claim.                                                                                  |
| `namespace`   | `string`                                                                                                                               | **yes**   | The namespace for this persistent volume claim.                                                                            |
| `spec`        | [`persistentvolumeclaim_spec`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#persistentvolumeclaimspec-v1-core) | **yes**   | The spec for this persistent volume claim.                                                                                 |
