# esxi/vm

An [Ansible](https://www.ansible.com) role used to create an [ESXi](https://www.vmware.com/products/esxi-and-esx.html)
VM.

# Usage

Provide a variable named `esxi_vm_params` of type [`esxi_vm_params`](#esxi_vm_params) when including/depending on this
role.

# Types

## `datastore`

### Description

Datastore information (e.g., where VMs and ISOs are to be stored).

### Schema

```yaml
iso:
  name:
  path:
vm:
  name:
  path:
```

| Name       | Type     | Required? | Description                                                     |
|------------|----------|-----------|-----------------------------------------------------------------|
| `iso.name` | `string` | no        | The name of the datastore where ISOs are stored.                |
| `iso.path` | `string` | no        | The path within the `iso.name` datastore where ISOs are stored. |
| `vm.name`  | `string` | no        | The name of the datastore where VMs are stored.                 |
| `vm.path`  | `string` | no        | The path within the `vm.name` datastore where VMs are stored.   |

## `esxi_server`

### Description

ESXi server information.

### Schema

```yaml
datacenter:
hostname:
password:
username:
```

| Name         | Type     | Required? | Description                             |
|--------------|----------|-----------|-----------------------------------------|
| `datacenter` | `string` | **yes**   | The name of the ESXi datacenter to use. |
| `hostname`   | `string` | **yes**   | The hostname of the ESXi server.        |
| `password`   | `string` | **yes**   | The password to use.                    |
| `username`   | `string` | **yes**   | The username to use.                    |

## `esxi_vm_params`

### Description

The parameters for this role.

### Schema

```yaml
datastore:
iso:
server:
vm_settings:
```

| Name          | Type                          | Required? | Description                                                      |
|---------------|-------------------------------|-----------|------------------------------------------------------------------|
| `datastore`   | [`datastore`](#datastore)     | no        | Datastore information.                                           |
| `iso`         | `string`                      | **yes**   | The path to the ISO image used to install the VM.                |
| `server`      | [`esxi_server`](#esxi_server) | **yes**   | Information for the ESXi server on which the VM will be created. |
| `vm_settings` | [`vm_settings`](#vm_settings) | **yes**   | The VM settings to use.                                          |

## `vm_settings`

### Description

Hardware settings for a VM.

### Schema

```yaml
boot_firmware:
disk_size:
guest_id:
memory:
network:
num_cpus:
version:
```

| Name          | Type                          | Required? | Description                                                      |
|---------------|-------------------------------|-----------|------------------------------------------------------------------|
|`boot_firmware`|`string`|**yes**|The boot firmware to use, either `bios` or `efi`.|
|`disk_size`|`integer`|**yes**|The size of the VM's hard disk, in GB.|
|`guest_id`|`string`|**yes**|A valid [VM guest identifier](https://vdc-download.vmware.com/vmwb-repository/dcr-public/da47f910-60ac-438b-8b9b-6122f4d14524/16b7274a-bf8b-4b4c-a05e-746f2aa93c8c/doc/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html).|
|`memory`|`integer`|**yes**|The amount of memory to allocate to the VM, in MB.|
|`network`|`string`|**yes**|The name of the ESXi virtual network to use.|
|`num_cpus`|`integer`|**yes**|The number of virtual CPUs to allocate to the VM.|
|`version`|`integer`|**yes**|A valid [VM hardware version](https://kb.vmware.com/s/article/1003746).|
