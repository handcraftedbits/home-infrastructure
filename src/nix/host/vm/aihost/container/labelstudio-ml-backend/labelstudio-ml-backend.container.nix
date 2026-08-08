{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=labelstudio-ml-backend
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/heartexlabs/labelstudio-ml-backend:yolo-master
Network=traefik.network
Volume=/mnt/container/models/vision:/app/models

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia1 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=labelstudio.service mnt-container.mount traefik.service
BindsTo=labelstudio.service
Description=Label Studio (ML Backend)
''
