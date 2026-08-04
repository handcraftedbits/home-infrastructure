{ pkgs, ... }:
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
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z searxng.app.howard.estate 443; do echo "Waiting for SearXNG..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
Description=SearXNG MCP Server
''
