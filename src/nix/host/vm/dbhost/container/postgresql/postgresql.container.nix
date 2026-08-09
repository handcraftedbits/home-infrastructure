{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=postgresql
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/pgvector/pgvector:pg18
Label=traefik.enable=true
Label=traefik.tcp.routers.postgresql.entrypoints=postgresql
Label=traefik.tcp.routers.postgresql.rule=HostSNI(`postgresql.db.howard.estate`)
Label=traefik.tcp.routers.postgresql.tls.certresolver=route53
Label=traefik.tcp.routers.postgresql.tls.options=postgresql@file
Label=traefik.tcp.services.postgresql.loadbalancer.server.port=5432
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/postgresql:/var/lib/postgresql

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=PostgreSQL
Wants=traefik.service
''
