# k8s/component/nfsprovisioner

An [Ansible](https://www.ansible.com) role used to enable an NFS
[persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) provisioner via
[nfs-client-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client).

# Usage

Provide a variable named `k8s_component_nfsprovisioner_params` of type
[`k8s_component_nfsprovisioner_params`](#k8s_component_nfsprovisioner_params) when including/depending on this role.

# Types

## `k8s_component_nfsprovisioner_params`

The parameters for this role.

### Schema

```yaml
archive_on_delete:
hostname:
mount_options:
name:
namespace:
path:
prefix:
storageclass_name:
```

| Name                | Type       | Required? | Description                                                                                              |
|---------------------|------------|-----------|----------------------------------------------------------------------------------------------------------|
| `archive_on_delete` | `boolean`  | **yes**   | Whether or not persistent volumes should be archived when deleted.                                       |
| `hostname`          | `string`   | **yes**   | The hostname of the NFS server.                                                                          |
| `mount_options`     | `string[]` | **yes**   | The [NFS mount options](https://linux.die.net/man/5/nfs) to use.                                         |
| `name`              | `string`   | **yes**   | The provisioner name to use.                                                                             |
| `namespace`         | `string`   | **yes**   | The namespace in which nfs-client-provisioner resources will be deployed.                                |
| `prefix`            | `string`   | **yes**   | The prefix for nfs-client-provisioner resources.                                                         |
| `storageclass_name` | `string`   | **yes**   | The name of the [storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/) to create. |
