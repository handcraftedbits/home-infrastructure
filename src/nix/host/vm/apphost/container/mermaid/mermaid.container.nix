{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=mermaid
Image=ghcr.io/mermaid-js/mermaid-live-editor:latest
Label=traefik.enable=true
Label=traefik.http.routers.mermaid.entrypoints=websecure
Label=traefik.http.routers.mermaid.rule=Host(`mermaid.app.howard.estate`)
Label=traefik.http.routers.mermaid.tls.certresolver=route53
Label=traefik.http.services.mermaid.loadbalancer.server.port=8080
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=traefik.service
Description=Mermaid
Wants=traefik.service
''
