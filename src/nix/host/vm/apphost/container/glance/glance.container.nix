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
Volume=%h/.config/glance:/app/config
Volume=%h/.local/share/glance/icons:/app/assets/icons:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=linkwarden.service
After=mnt-container.mount
After=traefik.service
Description=Glance
Wants=linkwarden.service
Wants=traefik.service
''
