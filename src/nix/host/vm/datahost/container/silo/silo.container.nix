{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=silo
EnvironmentFile=%h/.config/containers/environment/%N
Exec=server /data --console-address ":9001"
Image=docker.io/pgsty/silo:latest
Label=traefik.enable=true
Label=traefik.http.routers.silo.entrypoints=websecure
Label=traefik.http.routers.silo.rule=Host(`silo.app.howard.estate`)
Label=traefik.http.routers.silo.service=silo
Label=traefik.http.routers.silo.tls.certresolver=route53
Label=traefik.http.routers.silo-s3.entrypoints=websecure
Label=traefik.http.routers.silo-s3.rule=Host(`s3.howard.estate`)
Label=traefik.http.routers.silo-s3.service=silo-s3
Label=traefik.http.routers.silo-s3.tls.certresolver=route53
Label=traefik.http.services.silo.loadbalancer.server.port=9001
Label=traefik.http.services.silo-s3.loadbalancer.server.port=9000
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/silo:/data
Volume=/mnt/family:/volumes/family

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Silo
Wants=traefik.service
''
