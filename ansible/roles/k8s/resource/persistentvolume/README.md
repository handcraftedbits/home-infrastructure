# k8s/resource/persistentvolume

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes) resource.

# Usage

Provide a variable named `k8s_resource_persistentvolume_params` of type
[`k8s_resource_persistentvolume_params`](#k8s_resource_persistentvolume_params) when including/depending on this role.

# Types

## `k8s_resource_persistentvolume_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
spec:
volume_info:
```

| Name          | Type                                                                                                                         | Required? | Description                                                                                                                |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------- |
| `annotations` | `map`                                                                                                                        | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                                        | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                                     | **yes**   | The name of this persistent volume.                                                                                        |  |
| `spec`        | [`persistentvolume_spec`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#persistentvolumespec-v1-core) | **yes**   | The spec for this persistent volume.                                                                                       |
| `volume_info` | [`volume_source`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#volume-v1-core)                       | **yes**   | Configuration for the persistent volume that will be used.                                                                 |
