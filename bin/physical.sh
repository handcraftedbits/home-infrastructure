#!/bin/bash

age_key=
dir_base=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
dir_cache="${HOME}/.home-infrastructure/cache"
full_working_dir=
port=
working_dir=

. "${dir_base}/bin/common.sh"

print_help() {
     echo "Usage: $0 -a age_key -p port"
     echo
     echo "Options:"
     echo "  -a, --age-key age_key    (Required) The path to the private key used for decryption via age"
     echo "  -p, --port port          (Required) The port that the embedded HTTP server should use"
     echo "  -h, --help               Show this help message"
     echo
     echo "Example:"
     echo "  $0 -a /etc/ssh/age.key -p 8080"

     exit 1
}

while getopts ":a:p:h-:" opt
do
     case ${opt} in
          a) age_key="${OPTARG}" ;;
          p) port="${OPTARG}" ;;
          h) print_help ;;
          -)
               case "${OPTARG}" in
                    age-key) age_key="${!OPTIND}"; OPTIND=$(( OPTIND + 1 )) ;;
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

if [[ -z "${port}" ]]
then
     echo -e "Error: missing required argument -p.\n" >&2

     print_help
fi

mkdir -p "${dir_cache}/iso"

build_image_if_necessary infrastructure-runner
build_image_if_necessary physical-host

bootstrap_url="http://$(get_ip_address):${port}/bootstrap.json"
iso_filename="nixos-$(echo "${bootstrap_url}" | sed 's/[^a-zA-Z0-9]/_/g').iso"

"${docker}" run --rm \
     -v "${dir_cache}:/opt/container/cache" \
     -v "${docker_sock_file}:/var/run/docker.sock" \
     -e BUILD_ISO_BOOTSTRAP_URL="${bootstrap_url}" \
     -e BUILD_ISO_CACHE_DIR="${dir_cache}/iso" \
     -e BUILD_ISO_FILENAME="${iso_filename}" \
     --entrypoint /opt/container/bin/nixos/build-iso.sh \
     physical-host:latest

echo "ISO available at: ${dir_cache}/iso/${iso_filename}"

"${docker}" run -it --rm \
     -v "${age_key}:/opt/container/age.key:ro" \
     -v "${dir_cache}:/opt/container/cache" \
     -v "${dir_base}/src/secrets.age:/opt/container/secrets.age:ro" \
     -p "${port}:${port}" \
     physical-host:latest \
     "$(get_ip_address)" \
     "${port}" \
     "${working_dir}"
