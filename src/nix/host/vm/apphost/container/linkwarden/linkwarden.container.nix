{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=linkwarden
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/linkwarden/linkwarden:latest
Label=traefik.enable=true
Label=traefik.http.routers.linkwarden.entrypoints=websecure
Label=traefik.http.routers.linkwarden.rule=Host(`linkwarden.app.howard.estate`)
Label=traefik.http.routers.linkwarden.tls.certresolver=route53
Network=traefik.network
Volume=/mnt/container/linkwarden:/data/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=postgresql-available.service
After=traefik.service
Description=Linkwarden
Wants=postgresql-available.service
''
