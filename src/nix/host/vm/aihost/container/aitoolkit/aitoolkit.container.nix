{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=0
AutoUpdate=registry
ContainerName=aitoolkit
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/ostris/aitoolkit:latest
Label=traefik.enable=true
Label=traefik.http.routers.vllmcodingagent.entrypoints=websecure
Label=traefik.http.routers.vllmcodingagent.rule=Host(`aitoolkit.app.howard.estate`)
Label=traefik.http.routers.vllmcodingagent.tls.certresolver=route53
Label=traefik.http.services.vllmcodingagent.loadbalancer.server.port=8675
Network=traefik.network
Volume=/mnt/container/aitoolkit/aitk_db.db:/app/ai-toolkit/aitk_db.db
Volume=/mnt/container/aitoolkit/cache:/root/.cache/huggingface/hub
Volume=/mnt/container/aitoolkit/config:/app/ai-toolkit/config
Volume=/mnt/container/aitoolkit/datasets:/app/ai-toolkit/datasets
Volume=/mnt/container/aitoolkit/output:/app/ai-toolkit/output

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia0 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=AI Toolkit
''
