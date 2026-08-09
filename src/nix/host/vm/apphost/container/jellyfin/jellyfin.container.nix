{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=jellyfin
Image=docker.io/jellyfin/jellyfin:latest
Label=traefik.enable=true
Label=traefik.http.routers.jellyfin.entrypoints=websecure
Label=traefik.http.routers.jellyfin.rule=Host(`jellyfin.app.howard.estate`)
Label=traefik.http.routers.jellyfin.tls.certresolver=route53
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/jellyfin/cache:/cache
Volume=/mnt/container/jellyfin/runtime:/config
Volume=/mnt/media:/media:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
SuccessExitStatus=0 143
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=mnt-media.mount
After=traefik.service
Description=Jellyfin
Wants=traefik.service
''
