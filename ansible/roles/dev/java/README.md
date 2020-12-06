# dev/java

An [Ansible](https://www.ansible.com) role used to install [Java](https://www.oracle.com/technetwork/java/index.html)
configuration.

# Setup

The [Nexus OSS repository](https://oss.sonatype.org/) username and password should be stored on the
[Vault](https://www.vaultproject.io) server under the path `cubbyhole/dev/accounts/nexus` in the following format:

```json
{
  "password": "<nexus password>",
  "username": "<nexus username>",
}
```

# Usage

Provide a variable named `dev_java_params` of type [`dev_java_params`](#dev_java_params) when including/depending on
this role.

# Types

## `dev_java_params`

The parameters for this role.

### Schema

```yaml
nexus:
username:
```

| Name       | Type                              | Required? | Description                                          |
| ---------- | --------------------------------- | --------- | ---------------------------------------------------- |
| `nexus`    | [`nexus_account`](#nexus_account) | **yes**   | The Nexus OSS repository account information to use. |
| `username` | `string`                          | **yes**   | The name of the OS user for whom this role applies.  |

## `nexus_account`

Information about a Nexus OSS repository account.

### Schema

```yaml
password:
username:
```

| Name       | Type     | Required? | Description                               |
| ---------- | -------- | --------- | ----------------------------------------- |
| `password` | `string` | **yes**   | The Nexus OSS repository password to use. |
| `username` | `string` | **yes**   | The Nexus OSS repository username to use. |
