{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=mcp-searxng
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/isokoliuk/mcp-searxng:latest
Label=traefik.enable=true
Label=traefik.http.routers.mcpsearxng.entrypoints=websecure
Label=traefik.http.routers.mcpsearxng.rule=Host(`searxng.mcp.howard.estate`)
Label=traefik.http.routers.mcpsearxng.tls.certresolver=route53
Label=traefik.http.services.mcpsearxng.loadbalancer.server.port=3000
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z searxng.app.howard.estate 443; do echo "Waiting for SearXNG..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=traefik.service
Description=SearXNG MCP Server
''
