# dev/zsh

An [Ansible](https://www.ansible.com) role used to install [Zsh](http://zsh.sourceforge.net/), plugins, and
configuration.

# Usage

Provide a variable named `dev_zsh_params` of type [`dev_zsh_params`](#dev_zsh_params) when including/depending on
this role.

# Types

## `dev_zsh_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
