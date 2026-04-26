{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=immich-server
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/immich-app/immich-server:release
Label=traefik.enable=true
Label=traefik.http.routers.immich.entrypoints=websecure
Label=traefik.http.routers.immich.rule=Host(`immich.app.howard.estate`)
Label=traefik.http.routers.immich.tls.certresolver=route53
Label=traefik.http.services.immich.loadbalancer.server.port=2283
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/immich/data:/data

[Install]
WantedBy=default.target

[Service]
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z postgresql.db.howard.estate 5433; do echo "Waiting for database..."; ${pkgs.coreutils}/bin/sleep 2; done'
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z aihost.vm.lan.howard.estate 3003; do echo "Waiting for ML server..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=immich-valkey.service
After=mnt-container.mount
After=traefik.service
Description=Immich
Requires=immich-valkey.service
''
