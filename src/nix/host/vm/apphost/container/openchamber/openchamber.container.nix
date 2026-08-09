{ ... }:
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
Restart=always
TimeoutStartSec=900

[Unit]
After=llama-task-model-available.service
After=mnt-container.mount
After=traefik.service
After=vllm-coding-model-available.service
Description=OpenChamber
Wants=llama-task-model-available.service
Wants=openai-transcription-normalizer.service
Wants=traefik.service
Wants=vllm-coding-model-available.service
''
