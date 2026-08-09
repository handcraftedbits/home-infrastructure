{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=mcphub
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/samanhappy/mcphub:latest-full
Label=traefik.enable=true
Label=traefik.http.routers.mcphub.entrypoints=websecure
Label=traefik.http.routers.mcphub.rule=Host(`mcp.howard.estate`)
Label=traefik.http.routers.mcphub.tls.certresolver=route53
Label=traefik.http.services.mcphub.loadbalancer.server.port=3000
Network=traefik.network
Volume=%t/podman/podman.sock:/var/run/docker.sock
Volume=/mnt/container/mcphub/data:/app/data
Volume=/mnt/container/mcphub/settings.json:/app/mcp_settings.json

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mcp-jina.service
After=mcp-searxng.service
After=mnt-container.mount
After=podman.socket
After=traefik.service
BindsTo=podman.socket
Description=MCPHub
Wants=mcp-jina.service mcp-searxng.service
''
