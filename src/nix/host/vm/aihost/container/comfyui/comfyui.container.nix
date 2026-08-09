{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=0
AutoUpdate=registry
ContainerName=comfyui
Environment=WANTED_GID=%G
Environment=WANTED_UID=%U
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/mmartial/comfyui-nvidia-docker:ubuntu24_cuda13.1-latest
Label=traefik.enable=true
Label=traefik.http.routers.comfyui.entrypoints=websecure
Label=traefik.http.routers.comfyui.rule=Host(`comfyui.app.howard.estate`)
Label=traefik.http.routers.comfyui.tls.certresolver=route53
Label=traefik.http.services.comfyui.loadbalancer.server.port=8188
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/comfyui/run:/comfy/mnt
Volume=/mnt/container/comfyui/workspace:/basedir

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=nvidia-gpu-0-available.service
After=traefik.service
Description=ComfyUI
Wants=nvidia-gpu-0-available.service
''
