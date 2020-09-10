# k8s/resource/clusterrole

An [Ansible](https://www.ansible.com) role used to create a [cert-manager](https://docs.cert-manager.io/en/latest/)
[cluster issuer](https://cert-manager.readthedocs.io/en/latest/reference/clusterissuers.html) that works with
[Let's Encrypt](https://letsencrypt.org) and [Route53](https://aws.amazon.com/route53/).

# Usage

Provide a variable named `k8s_resource_clusterissuer_params` of type
[`k8s_resource_clusterissuer_params`](#k8s_resource_clusterissuer_params) when including/depending on this role.

# Types

## `k8s_resource_clusterissuer_params`

The parameters for this role.

### Schema

```yaml
access_key_id:
annotations:
email:
hosted_zone_id:
labels:
name:
region:
secret_access_key:
server:
```

| Name                | Type     | Required? | Description                                                                                                                                   |
|---------------------|----------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `access_key_id`     | `string` | **yes**   | The [AWS access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use.     |
| `annotations`       | `map`    | no        | The [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) to add to this resource.                    |
| `email`             | `string` | **yes**   | The email address used to make certificate requests.                                                                                          |
| `hosted_zone_id`    | `string` | **yes**   | The Route53 hosted zone ID to use.                                                                                                            |
| `labels`            | `map`    | no        | The [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/label/) to add to this resource.                               |
| `name`              | `string` | **yes**   | The name of this cluster issuer.                                                                                                              |
| `region`            | `string` | **yes**   | The AWS region to use.                                                                                                                        |
| `secret_access_key` | `string` | **yes**   | The [AWS secret access key](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use. |
| `server`            | `string` | **yes**   | The URL of the Let's Encrypt server to use.                                                                                                   |
