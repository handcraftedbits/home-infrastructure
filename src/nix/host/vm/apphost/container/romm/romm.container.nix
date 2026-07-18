{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=romm
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/rommapp/romm:latest
Label=traefik.enable=true
Label=traefik.http.routers.romm.entrypoints=websecure
Label=traefik.http.routers.romm.rule=Host(`romm.app.howard.estate`)
Label=traefik.http.routers.romm.tls.certresolver=route53
Label=traefik.http.services.romm.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/romm/assets:/romm/assets
Volume=/mnt/container/romm/config:/romm/config
Volume=/mnt/container/romm/library:/romm/library
Volume=/mnt/container/romm/redis:/redis-data
Volume=/mnt/container/romm/resources:/romm/resources

[Install]
WantedBy=default.target

[Service]
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z postgresql.db.howard.estate 5432; do echo "Waiting for database..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=RomM
''
