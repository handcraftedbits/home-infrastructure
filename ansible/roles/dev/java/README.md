# dev/java

An [Ansible](https://www.ansible.com) role used to install [Java](https://www.oracle.com/technetwork/java/index.html)
and associated tooling/configuration.

# Usage

Provide a variable named `dev_java_params` of type [`dev_java_params`](#dev_java_params) when including/depending on
this role.

# Types

## `dev_java_params`

The parameters for this role.

### Schema

```yaml
username:
version:
```

| Name             | Type       | Required? | Description                                         |
|------------------|------------|-----------|-----------------------------------------------------|
| `username`       | `string`   | **yes**   | The name of the OS user for whom this role applies. |
| `version`        | `string`   | no        | The version of Java to install.                       |
