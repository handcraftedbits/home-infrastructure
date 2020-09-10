# dev/vim

An [Ansible](https://www.ansible.com) role used to install [Neovim](https://neovim.io/), plugins, and configuration.

# Usage

Provide a variable named `dev_vim_params` of type [`dev_vim_params`](#dev_vim_params) when including/depending on
this role.

# Types

## `dev_vim_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
