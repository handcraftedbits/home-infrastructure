{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=searxng
EnvironmentFile=%h/.config/containers/environment/%N
HostName=searxng.app.howard.estate
Image=docker.io/searxng/searxng:latest
Label=traefik.enable=true
Label=traefik.http.routers.searxng.entrypoints=websecure
Label=traefik.http.routers.searxng.rule=Host(`searxng.app.howard.estate`)
Label=traefik.http.routers.searxng.tls.certresolver=route53
Label=traefik.http.services.searxng.loadbalancer.server.port=8080
Network=traefik.network
UserNS=keep-id
Volume=%h/.config/searxng:/etc/searxng
Volume=/mnt/container/searxng:/var/cache/searxng

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=SearXNG
''
