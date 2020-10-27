# dev/vim

An [Ansible](https://www.ansible.com) role used to install [Neovim](https://neovim.io/), plugins, and configuration on a
macOS system.

# Usage

Provide a variable named `mac_vim_params` of type [`mac_vim_params`](#mac_vim_params) when including/depending on
this role.

# Types

## `mac_vim_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
