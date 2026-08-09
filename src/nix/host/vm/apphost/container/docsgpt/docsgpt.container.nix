{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=docsgpt
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/arc53/docsgpt-fe:latest
Label=traefik.enable=true
Label=traefik.http.routers.docsgpt.entrypoints=websecure
Label=traefik.http.routers.docsgpt.rule=Host(`docsgpt.app.howard.estate`)
Label=traefik.http.routers.docsgpt.tls.certresolver=route53
Label=traefik.http.services.docsgpt.loadbalancer.server.port=5173
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=docsgpt-api-available.service
After=traefik.service
Description=DocsGPT
Wants=docsgpt-api-available.service
''
