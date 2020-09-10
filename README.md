# Home Infrastructure

[Ansible](https://www.ansible.com) playbooks, tools, and configuration used to manage home infrastructure.

# Executing Playbooks

Use `bin/ansible-playbook <dev|k8s> [options]` to run playbooks.  The script runs a Docker container that has all the
necessary dependencies and will look up the inventory file and other data from Vault.

The following [tags](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html) are defined:
  * `dev.aws` (install [AWS](https://aws.amazon.com/) client and configuration)
  * `dev.base` (install base VM dependencies)
  * `dev.cifs_client` (install CIFS client software and mount shares)
  * `dev.docker` (install [Docker](https://www.docker.com/) and associated tooling/configuration)
  * `dev.dotfiles` (install dot files)
  * `dev.go` (install [Go](https://golang.org/) and associated tooling/configuration)
  * `dev.java` (install [Java](https://www.oracle.com/technetwork/java/index.html) and associated
    tooling/configuration).
  * `dev.misc` (install miscellaneous packages).
  * `dev.nfs_client` (install NFS client software and mount shares)
  * `dev.terraform` (install [Terraform](https://terraform.io/))
  * `dev.tmux` (install [tmux](https://github.com/tmux/tmux) and associated configuration)
  * `dev.vim` (install [Neovim](https://neovim.io/), plugins, and configuration)
  * `dev.vscode` (install [code-server](https://github.com/cdr/code-server), plugins, and configuration)
  * `dev.zsh` (install [Zsh](http://zsh.sourceforge.net/), plugins, and configuration)
  * `k8s.apps` (install [Kubernetes](https://kubernetes.io) applications)
    * `k8s.apps.bitwarden` (install [Bitwarden](https://bitwarden.com/))
    * `k8s.apps.confluence` (install [Confluence](https://www.atlassian.com/software/confluence))
    * `k8s.apps.dashboard` (install Kubernetes dashboard)
    * `k8s.apps.jira` (install [JIRA](https://www.atlassian.com/software/jira))
    * `k8s.apps.mysql` (install [MySQL](https://mysql.org/) server)
    * `k8s.apps.openldap` (install [OpenLDAP](https://www.openldap.org))
    * `k8s.apps.organizr` (install [organizr](https://organizr.app/))
    * `k8s.apps.pgadmin` (install [pgAdmin](https://www.pgadmin.org/))
    * `k8s.apps.plantuml` (install [PlantUML](https://plantuml.com))
    * `k8s.apps.postgresql` (install [PostgreSQL](https://www.postgresql.org/) server)
    * `k8s.apps.sslterminator` (install SSL termination for various services)
  * `k8s.core` (install core Kubernetes cluster components)
  * `vm.create` (create VMs)
