# dev/sdkman

An [Ansible](https://www.ansible.com) role used to install [SDKMAN!](https://sdkman.io/) and associated
tooling/configuration.

# Usage

Provide a variable named `dev_sdkman_params` of type [`dev_sdkman_params`](#dev_sdkman_params) when including/depending
on this role.

# Types

## `dev_sdkman_params`

The parameters for this role.

### Schema

```yaml
username:
version:
```

| Name           | Type            | Required? | Description                                         |
| -------------- | --------------- | --------- | --------------------------------------------------- |
| `default_sdks` | [`sdk[]`](#sdk) | no        | The SDKs that should be marked as defaults.         |
| `default_sdks` | [`sdk[]`](#sdk) | no        | The SDKs that should be installed.                  |
| `username`     | `string`        | **yes**   | The name of the OS user for whom this role applies. |
| `version`      | `string`        | no        | The version of Java to install.                     |

## `sdk`

Information about a single SDK.

### Schema

```yaml
name:
version:
```

| Name      | Type     | Required? | Description          |
| --------- | -------- | --------- | -------------------- |
| `name`    | `string` | **yes**   | The name of the SDK. |
| `version` | `string` | **yes**   | The SDK version.     |
