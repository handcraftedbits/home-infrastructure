# dev/docker

An [Ansible](https://www.ansible.com) role used to install [Docker](https://www.docker.com/) and associated
tooling/configuration.

# Usage

Provide a variable named `dev_docker_params` of type [`dev_docker_params`](#dev_docker_params) when including/depending
on this role.

# Types

## `dev_docker_params`

The parameters for this role.

### Schema

```yaml
docker_compose_version:
username:
```

| Name                     | Type     | Required? | Description                                                                   |
|--------------------------|----------|-----------|-------------------------------------------------------------------------------|
| `docker_compose_version` | `string` | no        | The version of [Docker Compose](https://docs.docker.com/compose/) to install. |
| `username`               | `string` | **yes**   | The name of the OS user for whom this role applies.                           |
