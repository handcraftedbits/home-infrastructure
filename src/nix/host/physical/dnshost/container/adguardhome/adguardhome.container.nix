{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=adguardhome
Image=docker.io/adguard/adguardhome:latest
Label=traefik.enable=true
Label=traefik.http.routers.adguardhome.entrypoints=websecure
Label=traefik.http.routers.adguardhome.rule=Host(`admin.dns.lan.howard.estate`)
Label=traefik.http.routers.adguardhome.tls.certresolver=route53
Label=traefik.http.services.adguardhome.loadbalancer.server.port=80
Network=traefik.network
PublishPort=53:53/tcp
PublishPort=53:53/udp
Volume=%h/.local/share/container/adguardhome/config:/opt/adguardhome/conf
Volume=%h/.local/share/container/adguardhome/work:/opt/adguardhome/work

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=traefik.service
After=unison-sync.service
Description=AdGuard Home
Wants=unison-sync.service
''
