# Ansible Playbooks and Roles for Home Infrastructure

A collection of [Ansible](https://www.ansible.com) playbooks and roles for managing home infrastructure.

# Additional Requirements

* A [Vault](https://www.vaultproject.io) server.

# Roles

## Development Machine

* [dev/aws](roles/dev/aws/README.md)\
  Used to install the [AWS](https://aws.amazon.com/) client and associated configuration.
* [dev/base](roles/dev/base/README.md)\
  Used to install base VM dependencies.
* [dev/cifs_client](roles/dev/cifs_client/README.md)\
  Used to mount CIFS shares.
* [dev/docker](roles/dev/docker/README.md)\
  Used to install [Docker](https://www.docker.com/) and associated tooling/configuration.
* [dev/dotfiles](roles/dev/dotfiles/README.md)\
  Used to install dot files.
* [dev/gpg](roles/dev/gpg/README.md)\
  Used to install [GnuPG](https://gnupg.org/) and associated tooling/configuration.
* [dev/go](roles/dev/go/README.md)\
  Used to install [Go](https://golang.org/) and associated tooling/configuration.
* [dev/java](roles/dev/java/README.md)\
  Used to install [Java](https://www.oracle.com/technetwork/java/index.html) and associated tooling/configuration.
* [dev/misc](roles/dev/misc/README.md)\
  Used to install miscellaneous packages.
* [dev/nfs_client](roles/dev/nfs_client/README.md)\
  Used to mount NFS shares.
* [dev/go](roles/dev/go/README.md)\
  Used to install [Terraform](https://terraform.io/).
* [dev/tmux](roles/dev/tmux/README.md)\
  Used to install [tmux](https://github.com/tmux/tmux) and associated configuration.
* [dev/vim](roles/dev/vim/README.md)\
  Used to install [Neovim](https://neovim.io/), plugins, and configuration.
* [dev/vscode](roles/dev/vscode/README.md)\
  Used to install [code-server](https://github.com/cdr/code-server), plugins, and configuration.
* [dev/zsh](roles/dev/zsh/README.md)\
  Used to install [Zsh](http://zsh.sourceforge.net/), plugins, and configuration.

## ESXi

* [esxi/vm](roles/esxi/vm/README.md)\
  Used to create an [ESXi](https://www.vmware.com/products/esxi-and-esx.html) VM.

## Kubernetes

### Applications

* [k8s/app/bitwarden](roles/k8s/app/bitwarden/README.md)\
  Used to install a [Bitwarden](https://bitwarden.com/) server.
* [k8s/app/confluence](roles/k8s/app/confluence/README.md)\
  Used to install a [Confluence](https://www.atlassian.com/software/confluence) server.
* [k8s/app/dashboard](roles/k8s/app/dashboard/README.md)\
  Used to install the
  [Kubernetes dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).
* [k8s/app/jira](roles/k8s/app/jira/README.md)\
  Used to install a [JIRA](https://www.atlassian.com/software/jira) server.
* [k8s/app/mysql](roles/k8s/app/mysql/README.md)\
  Used to install a [MySQL](https://www.mysql.org/) server.
* [k8s/app/openldap](roles/k8s/app/openldap/README.md)\
  Used to install an [OpenLDAP](https://www.openldap.org) server using the
  [osixia/openldap](https://github.com/osixia/docker-openldap) [Docker](https://www.docker.com) image.
* [k8s/app/organizr](roles/k8s/app/organizr/README.md)\
  Used to install [organizr](https://organizr.app/).
* [k8s/app/pgadmin](roles/k8s/app/pgadmin/README.md)\
  Used to install [pgAdmin](https://www.pgadmin.org/).
* [k8s/app/plantuml](roles/k8s/app/plantuml/README.md)\
  Used to install a [PlantUML](https://plantuml.com) server.
* [k8s/app/postgresql](roles/k8s/app/postgresql/README.md)\
  Used to install a [PostgreSQL](https://www.postgresql.org/) server.
* [k8s/app/sslterminator](roles/k8s/app/sslterminator/README.md)\
  Used to perform SSL termination for external services.

### Components

* [k8s/component/certmanager](roles/k8s/component/certmanager/README.md)\
  Used to enable automatic certificate management via [cert-manager](https://docs.cert-manager.io/en/latest/).
* [k8s/component/externaldns](roles/k8s/component/externaldns/README.md)\
  Used to enable automatic external DNS updates via
  [external-dns](https://github.com/kubernetes-incubator/external-dns).
* [k8s/component/metallb](roles/k8s/component/metallb/README.md)\
  Used to create a [MetalLB](https://metallb.universe.tf) load balancer.
* [k8s/component/nfsprovisioner](roles/k8s/component/nfsprovisioner/README.md)\
  Used to enable an NFS [persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) provisioner
  via [nfs-client-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client).
* [k8s/component/nginx](roles/k8s/component/nginx/README.md)\
  Used to create an [NGiNX ingress](https://kubernetes.github.io/ingress-nginx).
* [k8s/core](roles/k8s/core/README.md)\
  Used to set up core pieces of a [Kubernetes](https://kubernetes.io) cluster.

### Resources

* [k8s/resource/certificate](roles/k8s/resource/certificate/README.md)\
  Used to create a [cert-manager](https://docs.cert-manager.io/en/latest/)
  [certificate](http://docs.cert-manager.io/en/latest/reference/certificates.html).
* [k8s/resource/clusterissuer](roles/k8s/resource/clusterissuer/README.md)\
  Used to create a [cert-manager](https://docs.cert-manager.io/en/latest/)
  [cluster issuer](https://cert-manager.readthedocs.io/en/latest/reference/clusterissuers.html) that works with
  [Let's Encrypt](https://letsencrypt.org) and [Route53](https://aws.amazon.com/route53/).
* [k8s/resource/clusterrole](roles/k8s/resource/clusterrole/README.md)\
  Used to create a Kubernetes
  [cluster role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) resource.
* [k8s/resource/clusterrolebinding](roles/k8s/resource/clusterrolebinding/README.md)\
  Used to create a Kubernetes
  [cluster role binding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding)
  resource.
* [k8s/resource/deployment](roles/k8s/resource/deployment/README.md)\
  Used to create a Kubernetes [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
  resource.
* [k8s/resource/helm](roles/k8s/resource/helm/README.md)\
  Used to deploy a [Helm](https://helm.sh) chart.
* [k8s/resource/ingress](roles/k8s/resource/ingress/README.md)\
  Used to create a Kubernetes [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) resource.
* [k8s/resource/namespace](roles/k8s/resource/namespace/README.md)\
  Used to create a Kubernetes [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
  resource.
* [k8s/resource/persistentvolume](roles/k8s/resource/persistentvolume/README.md)\
  Used to create a Kubernetes
  [persistent volume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes) resource.
* [k8s/resource/persistentvolumeclaim](roles/k8s/resource/persistentvolumeclaim/README.md)\
  Used to create a Kubernetes
  [persistent volume claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
  resource.
* [k8s/resource/secret](roles/k8s/resource/secret/README.md)\
  Used to create a Kubernetes [secret](https://kubernetes.io/docs/concepts/configuration/secret/) resource.
* [k8s/resource/service](roles/k8s/resource/service/README.md)\
  Used to create a Kubernetes [service](https://kubernetes.io/docs/concepts/services-networking/service/) resource.
* [k8s/resource/serviceaccount](roles/k8s/resource/serviceaccount/README.md)\
  Used to create a Kubernetes
  [service account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) resource.
* [k8s/resource/statefulset](roles/k8s/resource/statefulset/README.md)\
  Used to create a Kubernetes [stateful set](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
  resource.

## Mac

* [mac/base](roles/mac/base/README.md)\
  Used to install base dependencies and settings on a macOS system.
* [mac/dock](roles/mac/dock/README.md)\
  Used to set up the macOS dock.
* [mac/dotfiles](roles/mac/dotfiles/README.md)\
  Used to install dot files on a macOS system.
* [mac/java](roles/mac/java/README.md)\
  Used to install [Java](https://www.oracle.com/technetwork/java/index.html) and associated tooling/configuration on a
  macOS system.
* [mac/misc](roles/mac/misc/README.md)\
  Used to install miscellaneous packages on a macOS system.
* [mac/tmux](roles/mac/tmux/README.md)\
  Used to install [tmux](https://github.com/tmux/tmux) and associated configuration on a macOS system.
* [mac/vim](roles/mac/vim/README.md)\
  Used to install [Neovim](https://neovim.io/), plugins, and configuration on a macOS system.
* [mac/zsh](roles/mac/zsh/README.md)\
  Used to install [Zsh](http://zsh.sourceforge.net/), plugins, and configuration on a macOS system.

## VM

* [vm/alpine](roles/vm/alpine/README.md)\
  Used to create an [Alpine](https://alpinelinux.org)-based VM.
* [vm/k3s](roles/vm/k3s/README.md)\
  Used to create a VM that runs a [k3s](https://k3s.io) server or agent.

# Setup

* Create an `iso` directory in this directory.
* Create an Alpine installation ISO using
  [handcraftedbits/alpine-provision-ready](https://github.com/handcraftedbits/alpine-provision-ready):
  ```sh
  docker run -it --rm -v $(pwd)/iso:/iso -e ISO_GID=$(id -g) -e ISO_UID=$(id -u) handcraftedbits/alpine-provision-ready
  ```
* Create `group_vars/all/vault.json` containing:
  ```json
  {
    "vault": {
      "token": "<Vault server token>",
      "url": "<Vault server URL>"
    }
  }
  ```
* Create the following secrets on the Vault server:
  * `cubbyhole/ansible/inventory/home-infrastructure`:
    ```json
    {
      "all": {
        "children": {
          "dev": {
            "hosts": {
              "<dev machine host name>": {}
            }
          },
          "k8s_agents": {
            "hosts": {
              "<agent node host names...>": {}
            }
          },
          "k8s_servers": {
            "hosts": {
              "<server node host names...>": {}
            }
          },
          "k8s_stable": {
            "hosts": {
              "<agent node host names...>": {},
              "<server node host names...>": {}
            }
          },
          "work": {
            "hosts": {
              "<work machine host name>": {}
            }
          }
        }
      }
    }
    ```
  * `cubbyhole/dev/accounts/aws`:
    ```json
    {
      "access_key_id": "<AWS access key ID>",
      "region": "<AWS region>",
      "secret_access_key": "<AWS secret access key>"
    }
    ```
  * `cubbyhole/dev/accounts/cifs`:
    ```json
    {
      "password": "<CIFS password>",
      "username": "<CIFS username>"
    }
    ```
  * `cubbyhole/dev/accounts/default`:
    ```json
    {
      "password": "<default user password>",
      "username": "<default username>"
    }
    ```
  * `cubbyhole/esxi/esxi1`:
    ```json
    {
      "datacenter": "<datacenter name, typically 'ha-datacenter'>",
      "hostname": "<server hostname>",
      "password": "<password>",
      "username": "<username>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/accounts/root`:
    ```json
    {
      "password": "<root password for all VMs>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/accounts/webdav`:
    ```json
    {
      "username": "<WebDAV username",
      "password": "<WebDAV password>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/address-pools/default`:
    ```json
    {
      "addresses": "<range of IP addresses or CIDR-formatted IP address>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/address-pools/dns`:
    ```json
    {
      "addresses": "<range of IP addresses or CIDR-formatted IP address>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/certificate-issuers/production`:
    ```json
    {
      "access_key_id": "<AWS access key ID>",
      "email": "<email address>",
      "hosted_zone_id": "<Route53 hosted zone ID>",
      "region": "<AWS region>",
      "secret_access_key": "<AWS secret access key>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/certificate-issuers/staging`:
    ```json
    {
      "access_key_id": "<AWS access key ID>",
      "email": "<email address>",
      "hosted_zone_id": "<Route53 hosted zone ID>",
      "region": "<AWS region>",
      "secret_access_key": "<AWS secret access key>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/info`:
    ```json
    {
      "domain": "<domain suffix for the cluster>",
      "domain_reverse": "<reverse domain address for the cluster of the form 'x.y.z.in-addr.arpa.'>",
      "router_address": "<IP address of router that load balancer will communicate with>",
      "secret": "<cluster secret value>",
      "server_uri": "<master node hostname>:<master node port>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/storage/iscsi`:
    ```json
    {
      "iqn_base": "<IQN prefix (everything before ':')>",
      "portal_ip": "<iSCSI server IP address>",
      "portal_port": "<iSCSI server port>"
    }
    ```
  * `cubbyhole/k8s-cluster/stable/storage/nfs`:
    ```json
    {
      "hostname": "<hostname of NFS server>",
      "path": "<path where persistent volume storage is shared>"
    }
    ```
  * `cubbyhole/work/accounts/default`:
    ```json
    {
      "password": "<default user password>",
      "username": "<default username>"
    }
    ```
* See these roles for additional setup instructions:
  * [`dev/cifs_client`](roles/dev/cifs_client/README.md#setup)
  * [`dev/gpg`](roles/dev/gpg/README.md#setup)
  * [`dev/java`](roles/dev/java/README.md#setup)
  * [`dev/nfs`](roles/dev/nfs_client/README.md#setup)
  * [`k8s/app/mysql`](roles/k8s/app/mysql/README.md#setup):
    * `<cluster_name>`: `stable`
    * `<mysql_instance_name>`: `default`
  * [`k8s/app/openldap`](roles/k8s/app/openldap/README.md#setup):
    * `<cluster_name>`: `stable`
    * `<ldap_instance_name>`: `default`
  * [`k8s/app/postgresql`](roles/k8s/app/postgresql/README.md#setup):
    * `<cluster_name>`: `stable`
    * `<postgresql_instance_name>`: `default`
  * [`k8s/app/sslterminator`](roles/k8s/app/sslterminator/README.md#setup):
    * `<cluster_domain>`: `<cluster domain suffix>`
    * `<cluster_name>`: `stable`
* On macOS systems:
  * Enable SSH
  * Install XCode

# Types

## `account`

Information about an account.

### Schema

```yaml
password:
username:
```

| Name       | Type     | Required? | Description                                               |
| ---------- | -------- | --------- | --------------------------------------------------------- |
| `password` | `string` | **yes**   | The account's password.                                   |
| `username` | `string` | **yes**   | The account's username (which could be an email address). |

## `user`

Information about a user.

### Schema

```yaml
email:
first_name:
last_name:
password:
```

| Name         | Type     | Required? | Description               |
| ------------ | -------- | --------- | ------------------------- |
| `email`      | `string` | **yes**   | The user's email address. |
| `first_name` | `string` | **yes**   | The user's first name.    |
| `last_name`  | `string` | **yes**   | The user's last name.     |
| `password`   | `string` | **yes**   | The user's password.      |
