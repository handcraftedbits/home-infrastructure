{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=immich-valkey
Image=docker.io/valkey/valkey:9
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/immich/valkey:/data

[Install]
WantedBy=default.target

[Service]
Restart=always

[Unit]
After=mnt-container.mount
Description=Immich (Valkey)
''
