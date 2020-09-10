# k8s/resource/certificate

An [Ansible](https://www.ansible.com) role used to create a [cert-manager](https://docs.cert-manager.io/en/latest/)
[certificate](http://docs.cert-manager.io/en/latest/reference/certificates.html).

# Usage

Provide a variable named `k8s_resource_certificate_params` of type
[`k8s_resource_certificate_params`](#k8s_resource_certificate_params) when including/depending on this role.

# Types

## `k8s_resource_certificate_params`

The parameters for this role.

### Schema

```yaml
annotations:
labels:
name:
spec:
wait:
```

| Name          | Type                                                                                                               | Required? | Description                                                                                                                |
|---------------|--------------------------------------------------------------------------------------------------------------------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `annotations` | `map`                                                                                                              | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource. |
| `labels`      | `map`                                                                                                              | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.            |
| `name`        | `string`                                                                                                           | **yes**   | The name of this certificate.                                                                                              |
| `namespace`   | `string`                                                                                                           | **yes**   | The namespace for  this certificate.                                                                                       |
| `spec`        | [`certificate_spec`](http://docs.cert-manager.io/en/latest/reference/api-docs/index.html#certificatespec-v1alpha2) | **yes**   | The spec for this deployment.                                                                                              |
| `wait`        | `boolean`                                                                                                          | no        | Whether or not execution should wait until the certificate has been issued.                                                |
