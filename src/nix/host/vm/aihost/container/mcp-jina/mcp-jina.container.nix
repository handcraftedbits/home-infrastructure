{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=mcp-jina
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/handcraftedbits/jina-reader-mcp:latest
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=jina.service
BindsTo=jina.service
Description=Jina MCP Server
''
