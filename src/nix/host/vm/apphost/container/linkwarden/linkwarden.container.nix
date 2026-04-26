{ pkgs, ... }:
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
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z postgresql.db.howard.estate 5432; do echo "Waiting for database..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Linkwarden
''
