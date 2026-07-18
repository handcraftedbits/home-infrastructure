{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=forgejo
Environment=USER_GID=%G
Environment=USER_UID=%U
EnvironmentFile=%h/.config/containers/environment/%N
Image=codeberg.org/forgejo/forgejo:15-rootless
Label=traefik.enable=true
Label=traefik.http.routers.forgejo.entrypoints=websecure
Label=traefik.http.routers.forgejo.rule=Host(`forgejo.app.howard.estate`)
Label=traefik.http.routers.forgejo.tls.certresolver=route53
Label=traefik.http.services.forgejo.loadbalancer.server.port=3000
Label=traefik.tcp.routers.forgejo.entrypoints=forgejo
Label=traefik.tcp.routers.forgejo.rule=HostSNI(`*`)
Label=traefik.tcp.services.forgejo.loadbalancer.server.port=2222
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/forgejo:/var/lib/gitea
Volume=/etc/localtime:/etc/localtime:ro

[Install]
WantedBy=default.target

[Service]
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z postgresql.db.howard.estate 5432; do echo "Waiting for database..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=9000

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Forgejo
''
