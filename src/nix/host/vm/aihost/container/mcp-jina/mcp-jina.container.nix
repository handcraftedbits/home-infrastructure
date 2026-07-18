{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=mcp-jina
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/handcraftedbits/jina-reader-mcp:latest
Label=traefik.enable=true
Label=traefik.http.routers.mcpjina.entrypoints=websecure
Label=traefik.http.routers.mcpjina.rule=Host(`jina.mcp.howard.estate`)
Label=traefik.http.routers.mcpjina.tls.certresolver=route53
Label=traefik.http.services.mcpjina.loadbalancer.server.port=8000
Network=traefik.network

[Install]
WantedBy=default.target jina.service

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=jina.service traefik.service
BindsTo=jina.service
Description=Jina MCP Server
''
