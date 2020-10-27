# dev/tmux

An [Ansible](https://www.ansible.com) role used to install [tmux](https://github.com/tmux/tmux) and associated
configuration on a macOS system.

# Usage

Provide a variable named `mac_tmux_params` of type [`mac_tmux_params`](#mac_tmux_params) when including/depending on
this role.

# Types

## `mac_tmux_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
