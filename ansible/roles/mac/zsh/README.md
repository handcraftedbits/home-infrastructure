# dev/zsh

An [Ansible](https://www.ansible.com) role used to install [Zsh](http://zsh.sourceforge.net/), plugins, and
configuration on a macOS system.

# Usage

Provide a variable named `mac_zsh_params` of type [`mac_zsh_params`](#mac_zsh_params) when including/depending on
this role.

# Types

## `mac_zsh_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
