is_mac=$([[ "$OSTYPE" == "darwin"* ]] && echo "y" || echo "n")

build_image_if_necessary() {
     local image="$1"
     local image_build_dir="${dir_base}/src/docker/$1"
     local image_timestamp

     if [[ ! -d "${image_build_dir}" ]]
     then
          echo "Error: Docker image build directory ${image_build_dir} does not exist." >&2

          exit 1
     fi

     image_timestamp="$(docker inspect --format='{{.Metadata.LastTagTime}}' "${image}" 2> /dev/null || echo "")"

     if [[ -z "${image_timestamp}" ]]
     then
          echo "Image ${image} does not exist; building"

          "${docker}" build -t "${image}:latest" -f "${image_build_dir}/src/docker/Dockerfile" "${image_build_dir}/src"
     else
          local image_epoch_ms
          local newest_epoch_ms

          if [[ "${is_mac}" == "y" ]]
          then
               image_epoch_ms=$(date -ujf "%Y-%m-%d %H:%M:%S" "${image_timestamp%.*}" +%s 2>/dev/null)
          else
               image_epoch_ms=$(date -d "${image_timestamp}" +%s 2>/dev/null | xargs)
          fi

          # Find the latest timestamp within the image directory.
          if [[ "${is_mac}" == "y" ]]
          then
               newest_epoch_ms=$(find "${image_build_dir}" -type f -exec stat -f "%m" {} + | sort -n | tail -1)
          else
               newest_epoch_ms=$(find "${image_build_dir}" -type f -exec stat --format "%Y" {} + | sort -n | tail -1)
          fi

          if (( ${newest_epoch_ms} > ${image_epoch_ms} ))
          then
               echo "Image ${image} needs to be rebuilt due to updated or new content in ${image_build_dir}; building."

               "${docker}" build -t "${image}:latest" -f "${image_build_dir}/src/docker/Dockerfile" \
                    "${image_build_dir}/src"
          fi
     fi
}

detect_container_runtime() {
     if command -v docker &>/dev/null && docker info &>/dev/null 2>&1
     then
          docker="docker"
          docker_sock_file="/var/run/docker.sock"
     elif command -v podman &>/dev/null
     then
          docker="podman"

          if [ -S "/run/podman/podman.sock" ]
          then
               docker_sock_file="/run/podman/podman.sock"
          elif [ -S "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock" ]
          then
               docker_sock_file="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
          else
               echo "Podman socket not found - is the podman socket service running?" >&2

               return 1
          fi
     else
          echo "Neither docker nor podman found." >&2

          return 1
     fi
}

get_ip_address() {
     if [[ "${is_mac}" == "y" ]]
     then
          echo $(ipconfig getifaddr en0)
     else
          echo $(hostname -I | awk '{print $1}')
     fi
}

detect_container_runtime
