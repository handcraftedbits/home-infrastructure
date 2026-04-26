#!/bin/bash

age_key=
dir_base=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
full_working_dir=
ssh_auth_sock=
working_dir=

. "${dir_base}/bin/common.sh"

print_help() {
     echo "Usage: $0 -a age_key -d directory"
     echo
     echo "Options:"
     echo "  -a, --age-key age_key    (Required) The path to the private key used for decryption via age"
     echo "  -d, --directory dir      (Required) The directory containing OpenTofu files to use (relative to ${dir_base}/src/opentofu/docker)"
     echo "  -h, --help               Show this help message"
     echo
     echo "Example:"
     echo "  $0 -a /etc/ssh/age.key -d application"

     exit 1
}

while getopts ":a:d:h-:" opt
do
     case ${opt} in
          a) age_key="${OPTARG}" ;;
          d) working_dir="${OPTARG}" ;;
          h) print_help ;;
          -)
               case "${OPTARG}" in
                    age-key) age_key="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
                    directory) working_dir="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
                    help) print_help ;;
                    *) echo -e "Invalid option: --${OPTARG}\n" >&2; print_help ;;
               esac ;;
          \?) echo -e "Invalid option: -${OPTARG}\n" >&2; print_help ;;
          :) echo -e "Option -${OPTARG} requires an argument.\n" >&2; print_help ;;
     esac
done
shift $(( OPTIND - 1 ))

if [[ -z "${age_key}" ]]
then
     echo -e "Error: missing required argument -a.\n" >&2

     print_help
fi

if [[ ! -f "${age_key}" ]]
then
     echo -e "Error: age private key ${age_key} does not exist.\n" >&2

     print_help
fi

if [[ -z "${working_dir}" ]]
then
     echo -e "Error: missing required argument -d.\n" >&2

     print_help
fi

full_working_dir="${dir_base}/src/opentofu/docker/${working_dir}"

if [[ ! -d "${full_working_dir}" ]]
then
     echo -e "Error: directory ${full_working_dir} does not exist.\n" >&2

     print_help
fi

if [[ "${is_mac}" == "y" ]]
then
     ssh_auth_sock="/run/host-services/ssh-auth.sock"
else
     if [[ -z "${SSH_AUTH_SOCK}" ]]
     then
          echo -e "Error: SSH_AUTH_SOCK is not set. Please ensure ssh-agent is running.\n" >&2

          exit 1
     fi

     ssh_auth_sock="${SSH_AUTH_SOCK}"
fi

build_image_if_necessary infrastructure-runner

"${docker}" run -it --rm \
     -e SSH_AUTH_SOCK=/tmp/ssh_auth_sock \
     -v "${age_key}:/opt/container/age.key:ro" \
     -v "${dir_base}/src/secrets.age:/opt/container/secrets.age:ro" \
     -v "${dir_base}/src/opentofu/docker:/opt/container/opentofu" \
     -v "${ssh_auth_sock}:/tmp/ssh_auth_sock" \
     -w "/opt/container/opentofu/${working_dir}" \
     infrastructure-runner:latest \
     --constants-to-delete "nix" \
     --secrets-to-delete "esxi" \
     "$@"
