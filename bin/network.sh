#!/bin/bash

dir_base=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

. "${dir_base}/bin/common.sh"

print_help() {
     echo "Usage: $0 -a age_key"
     echo
     echo "Options:"
     echo "  -a, --age-key age_key    (Required) The path to the private key used for decryption via age"
     echo "  -h, --help               Show this help message"
     echo
     echo "Example:"
     echo "  $0 -a /etc/ssh/age.key"

     exit 1
}

while getopts ":a:h-:" opt
do
     case ${opt} in
          a) age_key="${OPTARG}" ;;
          h) print_help ;;
          -)
               case "${OPTARG}" in
                    age-key) age_key="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
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

build_image_if_necessary infrastructure-runner

"${docker}" run -it --rm \
     -v "${age_key}:/opt/container/age.key:ro" \
     -v "${dir_base}/src/secrets.age:/opt/container/secrets.age:ro" \
     -v "${dir_base}/src/opentofu:/opt/container/opentofu" \
     -w "/opt/container/opentofu/network" \
     infrastructure-runner:latest \
     --constants-to-delete "nix" \
     --secrets-to-delete "esxi" \
     "$@"
