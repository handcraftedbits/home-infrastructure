{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=litellm
Exec=--config /etc/litellm/config.yaml \
  --port 4000
Image=docker.litellm.ai/berriai/litellm:v1.90.2
Label=traefik.enable=true
Label=traefik.http.routers.litellm.entrypoints=websecure
Label=traefik.http.routers.litellm.rule=Host(`llm.howard.estate`)
Label=traefik.http.routers.litellm.tls.certresolver=route53
Label=traefik.http.services.litellm.loadbalancer.server.port=4000
Network=traefik.network
Volume=%h/.config/litellm:/etc/litellm:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=audio-cpp.service
After=llama-task-model.service
After=tei-embedding-model.service
After=traefik.service
After=vllm-coding-model.service
Description=LiteLLM Proxy
Wants=audio-cpp.service
Wants=llama-task-model.service
Wants=tei-embedding-model.service
Wants=traefik.service
Wants=vllm-coding-model.service
''
