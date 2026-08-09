{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=docsgpt-valkey
Image=docker.io/valkey/valkey:9
Network=traefik.network
UserNS=keep-id
Volume=/mnt/container/docsgpt/valkey:/data

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
Description=DocsGPT (Valkey)
''
