{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=navidrome
HostName=navidrome.app.howard.estate
Image=docker.io/deluan/navidrome:latest
Label=traefik.enable=true
Label=traefik.http.routers.navidrome.entrypoints=websecure
Label=traefik.http.routers.navidrome.rule=Host(`navidrome.app.howard.estate`)
Label=traefik.http.routers.navidrome.tls.certresolver=route53
Label=traefik.http.services.navidrome.loadbalancer.server.port=4533
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/navidrome:/data
Volume=/mnt/media/music:/music:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=mnt-media.mount
After=traefik.service
Description=Navidrome
''
