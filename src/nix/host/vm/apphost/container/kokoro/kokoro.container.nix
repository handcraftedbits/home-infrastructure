{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=kokoro
Image=ghcr.io/remsky/kokoro-fastapi-cpu:latest
Network=traefik.network

[Install]
WantedBy=default.target openwebui.service

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=openwebui.service traefik.service
BindsTo=openwebui.service
Description=Kokoro
''
