{ pkgs, ... }:
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
ExecStartPre=${pkgs.bash}/bin/bash -c 'until ${pkgs.netcat-openbsd}/bin/nc -z api.docsgpt.app.howard.estate 443; do echo "Waiting for DocsGPT API..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
Description=DocsGPT
''
