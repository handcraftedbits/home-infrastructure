{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=llama-task-model
Exec=--alias gemma4-e4b \
  --batch-size 8192 \
  --cache-type-k f16 \
  --cache-type-v f16 \
  --cont-batching \
  --ctx-size 524288 \
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
  --ubatch-size 2048
Image=ghcr.io/ggml-org/llama.cpp:server-cuda13
Label=traefik.enable=true
Label=traefik.http.routers.llama-task-model.entrypoints=websecure
Label=traefik.http.routers.llama-task-model.rule=Host(`task.llm.howard.estate`)
Label=traefik.http.routers.llama-task-model.tls.certresolver=route53
Label=traefik.http.services.llama-task-model.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/models/llm/gguf/gemma-4-E4B-it-qat-UD-Q4_K_XL.gguf:/opt/models/gemma-4-E4B-it-qat-UD-Q4_K_XL.gguf:ro
Volume=/mnt/container/models/llm/gguf/mtp-gemma-4-E4B-it-F16.gguf:/opt/models/mtp-gemma-4-E4B-it-F16.gguf:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=nvidia-gpu-1-available.service
After=traefik.service
Description=llama.cpp Task Model
Wants=nvidia-gpu-1-available.service
Wants=traefik.service
''
