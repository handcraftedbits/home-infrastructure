# dev/misc

An [Ansible](https://www.ansible.com) role used to install miscellaneous packages on a macOS system.

# Usage

Provide a variable named `mac_misc_params` of type [`mac_misc_params`](#mac_misc_params) when including/depending on
this role.

# Types

## `mac_misc_params`

The parameters for this role.

### Schema

```yaml
homebrew_packages:
homebrew_cask_packages:
```

| Name                     | Type       | Required? | Description                                                |
| ------------------------ | ---------- | --------- | ---------------------------------------------------------- |
| `homebrew_packages`      | `string[]` | no        | A list of [Homebrew](https://brew.sh) packages to install. |
| `homebrew_cask_packages` | `string[]` | no        | A list of Homebrew cask packages to install.               |
