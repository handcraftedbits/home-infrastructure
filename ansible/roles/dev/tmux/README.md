# dev/tmux

An [Ansible](https://www.ansible.com) role used to install [tmux](https://github.com/tmux/tmux) and associated
configuration.

# Usage

Provide a variable named `dev_tmux_params` of type [`dev_tmux_params`](#dev_tmux_params) when including/depending on
this role.

# Types

## `dev_tmux_params`

The parameters for this role.

### Schema

```yaml
username:
```

| Name       | Type     | Required? | Description                                         |
|------------|----------|-----------|-----------------------------------------------------|
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies. |
