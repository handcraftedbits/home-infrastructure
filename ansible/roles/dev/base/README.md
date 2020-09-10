# dev/base

An [Ansible](https://www.ansible.com) role used to install base VM dependencies.

# Usage

Provide a variable named `dev_base_params` of type [`dev_base_params`](#dev_base_params) when including/depending on
this role.

# Types

## `dev_base_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
