{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=openchamber
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/handcraftedbits/openchamber-docker:latest
Label=traefik.enable=true
Label=traefik.http.routers.openchamber.entrypoints=websecure
Label=traefik.http.routers.openchamber.rule=Host(`openchamber.app.howard.estate`)
Label=traefik.http.routers.openchamber.tls.certresolver=route53
Label=traefik.http.services.openchamber.loadbalancer.server.port=3000
Network=traefik.network
UserNS=keep-id
Volume=%h/.cache/opencode:/home/openchamber/.cache/opencode
Volume=%h/.config/opencode/.gitignore:/home/openchamber/.config/opencode/.gitignore
Volume=%h/.config/opencode/agents-default:/home/openchamber/.config/opencode/agents
Volume=%h/.config/opencode/node_modules:/home/openchamber/.config/opencode/node_modules
Volume=%h/.config/opencode/opencode-default.json:/home/openchamber/.config/opencode/opencode.json
Volume=%h/.config/opencode/package.json:/home/openchamber/.config/opencode/package.json
Volume=%h/.config/opencode/package-lock.json:/home/openchamber/.config/opencode/package-lock.json
Volume=%h/.config/opencode/skills:/home/openchamber/.config/opencode/skills
Volume=%h/.local/share/opencode:/home/openchamber/.local/share/opencode
Volume=%h/.local/state/opencode:/home/openchamber/.local/state/opencode
Volume=/mnt/container/openchamber/runtime:/home/openchamber/.config/openchamber
Volume=/mnt/container/openchamber/workspaces:/home/openchamber/workspaces

[Install]
WantedBy=default.target

[Service]
ExecStartPre=/bin/sh -c '\
  mkdir -p %h/.cache/opencode && \
  mkdir -p %h/.config/opencode && \
  mkdir -p %h/.config/opencode/node_modules && \
  mkdir -p %h/.local/share/opencode && \
  mkdir -p %h/.local/state/opencode && \
  \
  touch %h/.config/opencode/.gitignore && \
  \
  if [ ! -s %h/.config/opencode/package.json ]; then \
    echo "{}" > %h/.config/opencode/package.json; \
  fi; \
  \
  if [ ! -s %h/.config/opencode/package-lock.json ]; then \
    echo "{}" > %h/.config/opencode/package-lock.json; \
  fi; \
  \
  until ${pkgs.netcat-openbsd}/bin/nc -z coding.llm.howard.estate 443; do echo "Waiting for LLM server..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=Open WebUI
''

