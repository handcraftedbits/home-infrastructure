{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=vaultwarden
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/vaultwarden/server:latest
Label=traefik.enable=true
Label=traefik.http.routers.vaultwarden.entrypoints=websecure
Label=traefik.http.routers.vaultwarden.rule=Host(`vaultwarden.app.howard.estate`)
Label=traefik.http.routers.vaultwarden.tls.certresolver=route53
Network=traefik.network
Volume=/mnt/container/vaultwarden:/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Vaultwarden
''
