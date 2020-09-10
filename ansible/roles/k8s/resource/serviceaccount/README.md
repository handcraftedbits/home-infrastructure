# k8s/resource/serviceaccount

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[service account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) resource.

# Usage

Provide a variable named `k8s_resource_serviceaccount_params` of type
[`k8s_resource_serviceaccount_params`](#k8s_resource_serviceaccount_params) when including/depending on this role.

# Types

## `k8s_resource_serviceaccount_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
namespace:
```

| Name          | Type     | Required? | Description                                                                                                                |
|---------------|----------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`    | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`    | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string` | **yes**   | The name of this service account.                                                                                          |
| `namespace`   | `string` | **yes**   | The namespace for this service account.                                                                                    |
