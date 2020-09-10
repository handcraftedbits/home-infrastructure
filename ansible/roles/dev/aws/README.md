# dev/aws

An [Ansible](https://www.ansible.com) role used to install the [AWS](https://aws.amazon.com/) client and associated
configuration.

# Usage

Provide a variable named `dev_aws_params` of type [`dev_aws_params`](#dev_aws_params) when including/depending on this
role.

# Types

## `dev_aws_params`

The parameters for this role.

### Schema

```yaml
access_key_id:
region:
secret_access_key:
username:
```

| Name                | Type     | Required? | Description                                                                                                                                   |
|---------------------|----------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `access_key_id`     | `string` | **yes**   | The [AWS access key ID](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use.     |
| `region`            | `string` | **yes**   | The AWS region to use.                                                                                                                        |
| `secret_access_key` | `string` | **yes**   | The [AWS secret access key](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) to use. |
| `username`          | `string` | **yes**   | The name of the OS user for whom this role applies.                                                                                           |
