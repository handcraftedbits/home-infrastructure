{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=docsgpt-api
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/arc53/docsgpt:latest
Label=traefik.enable=true
Label=traefik.http.routers.docsgpt-api.entrypoints=websecure
Label=traefik.http.routers.docsgpt-api.rule=Host(`api.docsgpt.app.howard.estate`)
Label=traefik.http.routers.docsgpt-api.tls.certresolver=route53
Label=traefik.http.services.docsgpt-api.loadbalancer.server.port=7091
Network=traefik.network
Volume=/mnt/container/docsgpt/indexes:/app/indexes
Volume=/mnt/container/docsgpt/inputs:/app/inputs
Volume=/mnt/container/docsgpt/vectors:/app/vectors

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until ${pkgs.netcat-openbsd}/bin/nc -z postgresql.db.howard.estate 5432; do echo "Waiting for database..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=docsgpt-valkey.service mnt-container.mount tei-embedding-model.service
BindsTo=docsgpt-valkey.service tei-embedding-model.service
Description=DocsGPT (API)
''
