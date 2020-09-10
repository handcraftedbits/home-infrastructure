# dev/misc

An [Ansible](https://www.ansible.com) role used to install miscellaneous packages.

# Usage

Provide a variable named `dev_misc_params` of type [`dev_misc_params`](#dev_misc_params) when including/depending on
this role.

# Types

## `dev_misc_params`

The parameters for this role.

### Schema

```yaml
apt_packages:
pip_packages:
snap_packages:
username:
```

| Name              | Type       | Required? | Description                                                                                   |
| ----------------- | ---------- | --------- | --------------------------------------------------------------------------------------------- |
| `apt_packages`    | `string[]` | no        | A list of [APT](https://en.wikipedia.org/wiki/APT_(software)) packages to install.            |
| `pip`             | `string[]` | no        | A list of [pip](https://pypi.org/project/pip/) packages to install.                           |
| `snap_packages[]` | `string`   | no        | A list of [Snap](https://en.wikipedia.org/wiki/Snappy_(package_manager)) packages to install. |
| `username`        | `string`   | **yes**   | The name of the OS user for whom this role applies.                                           |

## `snap_package`

A single Snap package.

### Schema

```yaml
channel:
name:
```

| Name      | Type     | Required? | Description                              |
| --------- | -------- | --------- | ---------------------------------------- |
| `channel` | `string` | no        | The channel for the Snap package.        |
| `name`    | `string` | **yes**   | The name of the Snap package to install. |
