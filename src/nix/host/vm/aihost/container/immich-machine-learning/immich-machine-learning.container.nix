{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=immich-machine-learning
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/immich-app/immich-machine-learning:release-cuda
PublishPort=3003:3003
Volume=/mnt/container/immich/machine-learning/ml-dotcache:/.cache
Volume=/mnt/container/immich/machine-learning/ml-dotconfig:/.config
Volume=/mnt/container/immich/machine-learning/model-cache:/cache

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia1 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
Description=Immich (Machine Learning)
''
