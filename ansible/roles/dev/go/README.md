# dev/go

An [Ansible](https://www.ansible.com) role used to install [Go](https://golang.org/) and associated
tooling/configuration.

# Usage

Provide a variable named `dev_go_params` of type [`dev_go_params`](#dev_go_params) when including/depending on this
role.

# Types

## `dev_go_params`

The parameters for this role.

### Schema

```yaml
extra_packages:
paths:
  gopath:
  goroot:
username:
version:
```

| Name             | Type       | Required? | Description                                         |
|------------------|------------|-----------|-----------------------------------------------------|
| `extra_packages` | `string[]` | no        | Any extra packages to install.                      |
| `paths.gopath`   | `string`   | no        | The GOPATH to use.                                  |
| `paths.goroot`   | `string`   | no        | The GOROOT to use.                                  |
| `username`       | `string`   | **yes**   | The name of the OS user for whom this role applies. |
| `version`        | `string`   | no        | The version of Go to install.                       |
