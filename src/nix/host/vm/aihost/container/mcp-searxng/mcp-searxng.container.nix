{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=mcp-searxng
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/isokoliuk/mcp-searxng:latest
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=searxng-available.service
Description=SearXNG MCP Server
Wants=searxng-available.service
''
