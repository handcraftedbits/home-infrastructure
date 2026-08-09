{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=silverbullet
Image=docker.io/zefhemel/silverbullet:latest
Label=traefik.enable=true
Label=traefik.http.routers.silverbullet.entrypoints=websecure
Label=traefik.http.routers.silverbullet.rule=Host(`silverbullet.app.howard.estate`)
Label=traefik.http.routers.silverbullet.tls.certresolver=route53
Network=traefik.network
Volume=/mnt/container/silverbullet:/space

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Silverbullet
Wants=traefik.service
''
