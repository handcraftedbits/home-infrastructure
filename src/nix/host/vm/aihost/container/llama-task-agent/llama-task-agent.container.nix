{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=llama-task-agent
Exec=--alias gemma4-e4b \
  --batch-size 2048 \
  --cache-type-k f16 \
  --cache-type-v f16 \
  --cont-batching \
  --ctx-size 393216 \
  --flash-attn on \
  --host 0.0.0.0 \
  --jinja \
  --model /opt/models/gemma-4-E4B-it-qat-UD-Q4_K_XL.gguf \
  --model-draft /opt/models/mtp-gemma-4-E4B-it-F16.gguf \
  --n-gpu-layers all \
  --n-gpu-layers-draft all \
  --parallel 4 \
  --port 8080 \
  --spec-type draft-mtp \
  --spec-draft-n-max 4 \
  --ubatch-size 512
Image=ghcr.io/ggml-org/llama.cpp:server-cuda13
Label=traefik.enable=true
Label=traefik.http.routers.llamataskagent.entrypoints=websecure
Label=traefik.http.routers.llamataskagent.rule=Host(`task.llm.howard.estate`)
Label=traefik.http.routers.llamataskagent.tls.certresolver=route53
Label=traefik.http.services.llamataskagent.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/models/llm/gguf/gemma-4-E4B-it-qat-UD-Q4_K_XL.gguf:/opt/models/gemma-4-E4B-it-qat-UD-Q4_K_XL.gguf:ro
Volume=/mnt/container/models/llm/gguf/mtp-gemma-4-E4B-it-F16.gguf:/opt/models/mtp-gemma-4-E4B-it-F16.gguf:ro

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia1 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=llama.cpp Task Agent
''

