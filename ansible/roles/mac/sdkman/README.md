# mac/sdkman

An [Ansible](https://www.ansible.com) role used to install [SDKMAN!](https://sdkman.io/) and associated
tooling/configuration on a macOS system.

# Usage

Provide a variable named `mac_sdkman_params` of type [`mac_sdkman_params`](#mac_sdkman_params) when including/depending
on this role.

# Types

## `mac_sdkman_params`

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
