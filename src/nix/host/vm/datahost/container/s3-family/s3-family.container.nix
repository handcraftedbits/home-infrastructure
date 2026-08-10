{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=s3-family
EnvironmentFile=%h/.config/containers/environment/%N
Exec=serve s3 /volumes --addr :8080 --read-only
Image=docker.io/rclone/rclone:latest
Label=traefik.enable=true
Label=traefik.http.routers.s3-family.entrypoints=websecure
Label=traefik.http.routers.s3-family.rule=Host(`s3.howard.estate`)
Label=traefik.http.routers.s3-family.tls.certresolver=route53
Label=traefik.http.services.s3-family.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/family:/volumes/family:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=traefik.service
Description=Local S3 Buckets
Wants=traefik.service
''
