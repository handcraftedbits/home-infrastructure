# dev/terraform

An [Ansible](https://www.ansible.com) role used to install [Terraform](https://terraform.io/).

# Usage

Provide a variable named `dev_terraform_params` of type [`dev_terraform_params`](#dev_terraform_params) when
including/depending on this role.

# Types

## `dev_terraform_params`

The parameters for this role.

### Schema

```yaml
username:
version:
```

| Name       | Type     | Required? | Description                                         |
| ---------- | -------- | --------- | --------------------------------------------------- |
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
| `version`  | `string` | no        | The version of Terraform to install.                |
