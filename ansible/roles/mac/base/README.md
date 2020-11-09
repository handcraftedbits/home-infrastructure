# mac/base

An [Ansible](https://www.ansible.com) role used to install base dependencies and settings on a macOS system.

# Usage

Provide a variable named `mac_base_params` of type [`mac_base_params`](#mac_base_params) when including/depending on
this role.

# Types

## `mac_base_params`

The parameters for this role.

### Schema

```yaml
group:
username:
sudo_password:
```

| Name            | Type     | Required? | Description                                           |
| --------------- | -------- | --------- | ----------------------------------------------------- |
| `group`         | `string` | **yes**   | The name of the OS group for which this role applies. |
| `username`      | `string` | **yes**   | The name of the OS user for whom this role applies.   |
| `sudo_password` | `string` | **yes**   | The password to use when `sudo` is invoked.           |
