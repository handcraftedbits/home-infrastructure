# Pull the inventory out of Vault before running.

VAULT_TOKEN=$(cat group_vars/all/vault.json | jq -r '.vault.token')
VAULT_URL=$(cat group_vars/all/vault.json | jq -r '.vault.url')

VAULT_TOKEN=${VAULT_TOKEN} vault read --format=yaml -field=data --address=${VAULT_URL} \
     cubbyhole/ansible/inventory/home-infrastructure > /tmp/inventory.yaml

ansible-playbook $*

DIRS_REQUIRED="/root/.cache/helm /root/.config/helm /root/.kube /root/.local/share/helm /root/.ssh"

# Fix permissions, as anything written in the container is going to be owned by root.

for i in $(printf "%s\n" "${DIRS_REQUIRED}")
do
     if [ -d "${i}" ]
     then
          chown -R ${HOST_UID}:${HOST_GID} "${i}"
     fi
done
