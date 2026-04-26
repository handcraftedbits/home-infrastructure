#!/bin/bash

dir_base=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
dir_cache="${HOME}/.home-infrastructure/cache"
full_working_dir=""
port=""
working_dir=""

. "${dir_base}/bin/common.sh"

print_help() {
     echo "Usage: $0 -a age_key -d directory -p port"
     echo
     echo "Options:"
     echo "  -a, --age-key age_key    (Required) The path to the private key used for decryption via age"
     echo "  -d, --directory dir      (Required) The directory containing OpenTofu files to use (relative to ${dir_base}/src/opentofu/vm)"
     echo "  -p, --port port          (Required) The port that the embedded HTTP server should use"
     echo "  -h, --help               Show this help message"
     echo
     echo "Example:"
     echo "  $0 -a /etc/ssh/age.key -d filehost -p 8080"

     exit 1
}

while getopts ":a:d:p:h-:" opt
do
     case ${opt} in
          a) age_key="${OPTARG}" ;;
          d) working_dir="${OPTARG}" ;;
          p) port="${OPTARG}" ;;
          h) print_help ;;
          -)
               case "${OPTARG}" in
                    age-key) age_key="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
                    directory) working_dir="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
                    port) port="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
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

full_working_dir="${dir_base}/src/opentofu/vm/${working_dir}"

if [[ ! -d "${full_working_dir}" ]]
then
     echo -e "Error: directory ${full_working_dir} does not exist.\n" >&2

     print_help
fi

if [[ -z "${port}" ]]
then
     echo -e "Error: missing required argument -p.\n" >&2

     print_help
fi

mkdir -p ${dir_cache}/iso

build_image_if_necessary infrastructure-runner

"${docker}" run -it --rm \
     -v "${age_key}:/opt/container/age.key:ro" \
     -v "${dir_cache}:/opt/container/cache" \
     -v "${dir_base}/src/opentofu:/opt/container/opentofu" \
     -v "${dir_base}/src/secrets.age:/opt/container/secrets.age:ro" \
     -v "${docker_sock_file}:/var/run/docker.sock:ro" \
     -p "${port}:${port}" \
     -w "/opt/container/opentofu/vm/${working_dir}" \
     infrastructure-runner:latest \
     --secrets-to-delete "keys" \
     "$@" \
     --var="cache_dir=${dir_cache}" \
     --var="http_server={\"host\": \"$(get_ip_address)\", \"port\": ${port}}"
