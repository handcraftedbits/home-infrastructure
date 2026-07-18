{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=localai
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/localai/localai:latest-gpu-nvidia-cuda-12
Label=traefik.enable=true
Label=traefik.http.routers.localai.entrypoints=websecure
Label=traefik.http.routers.localai.rule=Host(`localai.app.howard.estate`)
Label=traefik.http.routers.localai.tls.certresolver=route53
Label=traefik.http.services.localai.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/localai/backends:/backends
Volume=/mnt/container/localai/configuration:/configuration
Volume=/mnt/container/localai/data:/data
Volume=/mnt/container/localai/media:/media
Volume=/mnt/container/localai/models:/models

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia1 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=LocalAI
''
