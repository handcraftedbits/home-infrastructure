# k8s/resource/clusterrolebinding

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[cluster role binding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding)
resource.

# Usage

Provide a variable named `k8s_resource_clusterrolebinding_params` of type
[`k8s_resource_clusterrolebinding_params`](#k8s_resource_clusterrolebinding_params) when including/depending on this
role.

# Types

## `k8s_resource_clusterrolebinding_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
role_ref:
subjects:
```

| Name          | Type                                                                                                                    | Required? | Description                                                                                                                |
|---------------|-------------------------------------------------------------------------------------------------------------------------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`                                                                                                                   | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                                   | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                                | **yes**   | The name of this cluster role binding.                                                                                     |
| `role_ref`    | [`role_ref`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#roleref-v1-rbac-authorization-k8s-io) | **yes**   | A reference to the cluster role being bound.                                                                               |
| `subjects`    | [`subjects`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#subject-v1-rbac-authorization-k8s-io) | **yes**   | The list of subjects who are being assigned a cluster role.                                                                |
