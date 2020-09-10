# k8s/resource/clusterrole

An [Ansible](https://www.ansible.com) role used to create a [Kubernetes](https://kubernetes.io)
[cluster role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) resource.

# Usage

Provide a variable named `k8s_resource_clusterrole_params` of type
[`k8s_resource_clusterrole_params`](#k8s_resource_clusterrole_params) when including/depending on this role.

# Types

## `k8s_resource_clusterrole_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
rules:
```

| Name          | Type                                                                                                                           | Required? | Description                                                                                                                |
|---------------|--------------------------------------------------------------------------------------------------------------------------------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`                                                                                                                          | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                                          | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                                       | **yes**   | The name of this cluster role.                                                                                             |
| `rules`       | [`policy_rules`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.16/#policyrule-v1-rbac-authorization-k8s-io) | **yes**   | The policy rules to attach to this cluster role.                                                                           |
