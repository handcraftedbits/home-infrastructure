# k8s/app/sslterminator

An [Ansible](https://www.ansible.com) role used to perform SSL termination for an external service.

# Setup

Create a secret in the [Vault](https://www.vaultproject.io) server under the path
`cubbyhole/k8s-cluster/<cluster_name>/sslterminators` with type [`map[string -> endpoint]`](#endpoint), e.g.:

```json
{
  "<name>": {
    "annotations": {
      "nginx.ingress.kubernetes.io/configuration-snippet": "more_set_headers \"Content-Security-Policy: frame-ancestors https://*.<cluster_domain>\";\nproxy_hide_header X-Frame-Options;"
    },
    "target_hostname": "<hostname>",
    "target_port": <port>
  },
  ...
}
```

The annotation above will ensure that the application proxied by this SSL terminator can be embedded in an iframe when
linked to [k8s/app/organizer](../organizr/README.md).

# Usage

Provide a variable named `k8s_app_sslterminator_params` of type
[`k8s_app_sslterminator_params`](#k8s_app_sslterminator_params) when including/depending on this role.

The external service will be available, with SSL terminatiion, at `https://<hostname>`.

# Types

## `endpoint`

A single external service endpoint.

### Schema

```yaml
secure:
target_hostname:
target_port:
```

| Name              | Type      | Required? | Description                                                        |
| ----------------- | --------- | --------- | ------------------------------------------------------------------ |
| `secure`          | `boolean` | no        | Whether or not the external service is using HTTPS.                |
| `target_hostname` | `string`  | **yes**   | The hostname of the external service which will be SSL-terminated. |
| `target_port`     | `integer` | **yes**   | The port of the external service which will be SSL-terminated.     |

## `k8s_app_sslterminator_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
endpoints:
hostname_suffix:
namespace:
```

| Name                 | Type                                   | Required? | Description                                                           |
| -------------------- | -------------------------------------- | --------- | --------------------------------------------------------------------- |
| `certificate_issuer` | `string`                               | **yes**   | The name of the certificate issuer to use.                            |
| `endpoints`          | [`map[string -> endpoint]`](#endpoint) | **yes**   | A mapping of names to external services which will be SSL-terminated. |
| `hostname_suffix`    | `string`                               | **yes**   | The hostname suffix to use.                                           |
| `namespace`          | `string`                               | no        | The namespace in which sslterminator resources will be deployed.      |
