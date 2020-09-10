# vm/k3s

An [Ansible](https://www.ansible.com) role used to create a VM that runs a [k3s](https://k3s.io) server or agent.

# Usage

Provide a variable named `vm_k3s_params` of type [`vm_k3s_params`](#vm_k3s_params) when including/depending on this
role.

# Types

## `vm_k3s_params`

The parameters for this role.

### Schema

```yaml
esxi_server:
server_uri:
token:
type:
version:
vm_settings:
```

| Name             | Type                                                 | Required? | Description                                                                                            |
|------------------|------------------------------------------------------|-----------|--------------------------------------------------------------------------------------------------------|
| `token` | `string`                                             | **yes**   | The token provided by agents when joining the server.                                         |
| `esxi_server`    | [`esxi_server`](../../esxi/vm/README.md#esxi_server) | **yes**   | ESXi server information.                                                                               |
| `server_uri`     | `string`                                             | no        | The URI of the server that an agent should connect to (`host:port`).  Required when `type` is `agent`. |
| `type`           | `string`                                             | **yes**   | The type of node to create, `agent` or `server`.                                                       |
| `version`        | `string`                                             | no        | The k3s version to install.                                                                            |
| `vm_settings`    | [`vm_settings`](../../esxi/vm/README.md#vm_settings) | no        | The VM settings to use.                                                                                |
