# dev/dotfiles

An [Ansible](https://www.ansible.com) role used to install dot files.

# Usage

Provide a variable named `dev_dotfiles_params` of type [`dev_dotfiles_params`](#dev_dotfiles_params) when
including/depending on this role.

# Types

## `dev_dotfiles_params`

The parameters for this role.

### Schema

```yaml
dir:
repo:
username:
```

| Name       | Type     | Required? | Description                                                  |
|------------|----------|-----------|--------------------------------------------------------------|
| `dir`      | `string` | no        | The directory where the dot files repository will be stored. |
| `repo`     | `string` | **yes**   | The Git repository containing dot files.                     |
| `username` | `string` | **yes**   | The name of the OS user for whom this role applies.          |
