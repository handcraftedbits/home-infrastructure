{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=openwebui
HostName=openwebui.app.howard.estate
Image=ghcr.io/open-webui/open-webui:main
Label=traefik.enable=true
Label=traefik.http.routers.openwebui.entrypoints=websecure
Label=traefik.http.routers.openwebui.rule=Host(`openwebui.app.howard.estate`)
Label=traefik.http.routers.openwebui.tls.certresolver=route53
Label=traefik.http.services.openwebui.loadbalancer.server.port=8080
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/openwebui:/app/backend/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Open WebUI
''
