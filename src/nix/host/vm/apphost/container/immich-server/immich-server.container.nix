{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=immich-server
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/immich-app/immich-server:release
Label=traefik.enable=true
Label=traefik.http.routers.immich-server.entrypoints=websecure
Label=traefik.http.routers.immich-server.rule=Host(`immich.app.howard.estate`)
Label=traefik.http.routers.immich-server.tls.certresolver=route53
Label=traefik.http.services.immich-server.loadbalancer.server.port=2283
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/immich/data:/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=immich-machine-learning-available.service
After=immich-valkey.service
After=mnt-container.mount
After=postgresql-available.service
After=traefik.service
BindsTo=immich-valkey.service
Description=Immich
Wants=immich-machine-learning-available.service
Wants=postgresql-available.service
''
