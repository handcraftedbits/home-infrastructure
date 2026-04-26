#!/bin/bash

constants_file=/opt/container/src/template/constants.tfvars.json
constants_to_delete=
secrets_to_delete=

while [[ $# -gt 0 ]]
do
  case "$1" in
    --constants-to-delete) constants_to_delete="$2"; shift 2 ;;
    --secrets-to-delete) secrets_to_delete="$2"; shift 2 ;;
    *) break ;;
  esac
done

# Decrypt secrets.
age -d -i /opt/container/age.key /opt/container/secrets.age > /tmp/secrets.json

# Create AWS credentials from secrets file.
mkdir -p /root/.aws
jq -r '"[default]\noutput = \(.aws.output)\nregion = \(.aws.region)"' /tmp/secrets.json > /root/.aws/config
jq -r '"[default]\naws_access_key_id = \(.aws.access_key_id)\naws_secret_access_key = \(.aws.secret_access_key)"' \
  /tmp/secrets.json > /root/.aws/credentials

# Remove certain secrets and constants in order to keep OpenTofu from complaining.
if [ -n "${secrets_to_delete}" ]
then
  jq "del(.aws, $(echo "${secrets_to_delete}" | sed 's/,/,./g; s/^/./'))" /tmp/secrets.json > /tmp/secrets.tfvars.json
else
  jq 'del(.aws)' /tmp/secrets.json > /tmp/secrets.tfvars.json
fi

if [ -n "${constants_to_delete}" ]
then
  jq "del($(echo "${constants_to_delete}" | sed 's/,/,./g; s/^/./'))" "${constants_file}" > /tmp/constants.tfvars.json

  constants_file=/tmp/constants.tfvars.json
fi

case "$1" in
  apply|destroy|import|plan|refresh) exec tofu "$1" \
    --var-file="${constants_file}" \
    --var-file=/tmp/secrets.tfvars.json \
    "${@:2}" ;;
  *) exec tofu "$@" ;;
esac
