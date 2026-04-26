#!/bin/bash

age_private_key="${START_HOST_AGE_PRIVATE_KEY}"
anonymous_flake_url="${START_HOST_ANONYMOUS_FLAKE_URL}"
flake_path="${START_HOST_FLAKE_PATH}"
flake_url="${START_HOST_FLAKE_URL}"
host="${START_HOST_HOST}"
port="${START_HOST_PORT}"
temp_dir=$(mktemp -d)
type="${START_HOST_TYPE}"
vm_hostname="${START_HOST_VM_HOSTNAME}"

cat > "${temp_dir}/bootstrap.json" << EOF
{
  "age": {
    "installPath": "/etc/age-key",
    "privateKey": "$(awk '{printf "%s\\n", $0}' "${age_private_key}")"
  },
  "anonymousFlakeUrl": "${anonymous_flake_url}",
  "disk": "/dev/sda",
  "flakePath": "${flake_path}",
  "flakeUrl": "${flake_url}",
  "host": "${vm_hostname}"
}
EOF

echo -e "Starting HTTP server on host ${host}, port ${port} using bootstrap.json:\n"
echo "$(jq '.age.privateKey = "<REDACTED>"' < "${temp_dir}/bootstrap.json")"

if [[ "${type}" == "physical" ]]
then
     busybox httpd -p "${port}" -h "${temp_dir}" -f
else
     busybox httpd -p "${port}" -h "${temp_dir}"
fi
