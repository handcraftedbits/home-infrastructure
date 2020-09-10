# k8s/app/plantuml

An [Ansible](https://www.ansible.com) role used to install a [PlantUML](https://plantuml.com) server.

# Usage

Provide a variable named `k8s_app_plantuml_params` of type [`k8s_app_plantuml_params`](#k8s_app_plantuml_params) when
including/depending on this role.

The PlantUML server will be available at `https://<hostname>/`.

# Types

## `k8s_app_plantuml_params`

The parameters for this role.

### Schema

```yaml
certificate_issuer:
hostname:
na:
namespace:
```

| Name                 | Type     | Required? | Description                                                 |
| -------------------- | -------- | --------- | ----------------------------------------------------------- |
| `certificate_issuer` | `string` | **yes**   | The name of the certificate issuer to use.                  |
| `hostname`           | `string` | **yes**   | The hostname to use.                                        |
| `name`               | `string` | **yes**   | The name for the installation.                              |
| `namespace`          | `string` | no        | The namespace in which PlantUML resources will be deployed. |
