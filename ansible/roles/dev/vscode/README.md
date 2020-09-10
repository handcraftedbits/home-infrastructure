# dev/vscode

An [Ansible](https://www.ansible.com) role used to install [code-server](https://github.com/cdr/code-server), plugins,
and configuration.

# Usage

Provide a variable named `dev_vscode_params` of type [`dev_vscode_params`](#dev_vscode_params) when including/depending
on this role.

# Types

## `dev_vscode_params`

The parameters for this role.

### Schema

```yaml
extensions:
password:
port:
username:
version:
```

| Name         | Type       | Required? | Description                                         |
|--------------|------------|-----------|-----------------------------------------------------|
| `extensions` | `string[]` | no        | Any additional extensions to install.               |
| `password`   | `string`   | **yes**   | The password used to protect code-server.           |
| `port`       | `integer`  | **yes**   | The port code-server will run on.                   |
| `username`   | `string`   | **yes**   | The name of the OS user for whom this role applies. |
| `version`    | `string`   | no        | The version of code-server to install.              |
