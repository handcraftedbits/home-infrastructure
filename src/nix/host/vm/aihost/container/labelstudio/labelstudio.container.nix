
{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=labelstudio
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/heartexlabs/label-studio:latest
Label=traefik.enable=true
Label=traefik.http.routers.labelstudio.entrypoints=websecure
Label=traefik.http.routers.labelstudio.rule=Host(`labelstudio.app.howard.estate`)
Label=traefik.http.routers.labelstudio.tls.certresolver=route53
Label=traefik.http.services.labelstudio.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/family:/media/family:ro
Volume=/mnt/container/labelstudio:/label-studio/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
Description=Label Studio
''
