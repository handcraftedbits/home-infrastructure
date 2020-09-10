# k8s/app/dashboard

An [Ansible](https://www.ansible.com) role used to install the
[Kubernetes dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

# Usage

Provide a variable named `k8s_app_dashboard_params` of type [`k8s_app_dashboard_params`](#k8s_app_dashboard_params) when
including/depending on this role.

Note that to log in you need to find the token located in a secret named `<prefix>-token-<random>` in the `<namespace>`
namespace:

```sh
kubectl get secret <prefix>-token-<random> -n <namespace> -o json | jq -r '.data.token' | base64 -d
```

# Types

## `k8s_app_dashboard_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
cluster_domain:
hostname:
namespace:
prefix:
```

| Name                 | Type     | Required? | Description                                                                  |
| -------------------- | -------- | --------- | ---------------------------------------------------------------------------- |
| `certificate_issuer` | `string` | **yes**   | The name of the certificate issuer to use.                                   |
| `cluster_domain`     | `string` | **yes**   | The domain suffix of the Kubernetes cluster where this resource is deployed. |
| `hostname`           | `string` | **yes**   | The hostname to use.                                                         |
| `namespace`          | `string` | no        | The namespace in which Kubernetes dashboard resources will be deployed.      |
| `prefix`             | `string` | no        | The prefix for Kubernetes dashboard resources.                               |
