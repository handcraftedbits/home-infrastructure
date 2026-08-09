{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=jina
Image=ghcr.io/jina-ai/reader:oss
Label=traefik.enable=true
Label=traefik.http.routers.jina.entrypoints=websecure
Label=traefik.http.routers.jina.rule=Host(`jina.app.howard.estate`)
Label=traefik.http.routers.jina.tls.certresolver=route53
Label=traefik.http.services.jina.loadbalancer.server.port=8081
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=traefik.service
Description=Jina
Wants=mcp-jina.service
Wants=traefik.service
''
