# k8s/resource/deployment

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) resource.

# Usage

Provide a variable named `k8s_resource_deployment_params` of type
[`k8s_resource_deployment_params`](#k8s_resource_deployment_params) when including/depending on this role.

# Types

## `k8s_resource_deployment_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
namespace:
spec:
```

| Name          | Type                                                                                                                  | Required? | Description                                                                                                                |
|---------------|-----------------------------------------------------------------------------------------------------------------------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`                                                                                                                 | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                                 | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                              | **yes**   | The name of this deployment.                                                                                               |
| `namespace`   | `string`                                                                                                              | **yes**   | The namespace for this deployment.                                                                                         |
| `spec`        | [`deployment_spec`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#deploymentspec-v1beta1-apps) | **yes**   | The spec for this deployment.                                                                                              |
