#!/bin/bash

export START_HOST_AGE_PRIVATE_KEY="/opt/container/age.key"
export START_HOST_ANONYMOUS_FLAKE_URL="$(jq -r '.nix.anonymous_flake_url' /opt/container/src/template/constants.tfvars.json)"
export START_HOST_DATA_DIR="/opt/container/data"
export START_HOST_FLAKE_URL="$(jq -r '.nix.flake_url' /opt/container/src/template/constants.tfvars.json)"
export START_HOST_HOST="$1"
export START_HOST_PORT="$2"
export START_HOST_TYPE="physical"
export START_HOST_VM_HOSTNAME="$3"

/opt/container/bin/nixos/start-host.sh
