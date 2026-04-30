{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=glance
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/glanceapp/glance:latest
Label=traefik.enable=true
Label=traefik.http.routers.glance.entrypoints=websecure
Label=traefik.http.routers.glance.rule=Host(`frontdoor.howard.estate`)
Label=traefik.http.routers.glance.tls.certresolver=route53
Label=traefik.http.services.glance.loadbalancer.server.port=8080
Network=traefik.network
UserNS=keep-id
Volume=%h/.local/share/glance/icons:/app/assets/icons:ro
Volume=%h/.config/glance:/app/config

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Glance
''
