{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=0
AutoUpdate=registry
ContainerName=vllm-coding-model
EnvironmentFile=%h/.config/containers/environment/%N
Exec=/opt/models/gemma-4-31B-it-FP8-dynamic \
  --chat-template examples/tool_chat_template_gemma4.jinja \
  --default-chat-template-kwargs '{"enable_thinking": true, "preserve_thinking": true}' \
  --dtype auto \
  --enable-auto-tool-choice \
  --enable-chunked-prefill \
  --enable-log-requests \
  --enable-prefix-caching \
  --host 0.0.0.0 \
  --kv-cache-dtype bfloat16 \
  --kv-cache-memory-bytes 48G \
  --max-model-len 262144 \
  --max-num-batched-tokens 32768 \
  --port 8000 \
  --reasoning-parser gemma4 \
  --served-model-name gemma4-31b \
  --speculative-config '{"model":"/opt/models/gemma-4-31B-it-assistant","num_speculative_tokens":4}' \
  --tensor-parallel-size 1 \
  --tool-call-parser gemma4
Image=docker.io/vllm/vllm-openai:v0.25.1
Label=traefik.enable=true
Label=traefik.http.routers.vllm-coding-model.entrypoints=websecure
Label=traefik.http.routers.vllm-coding-model.rule=Host(`coding.llm.howard.estate`)
Label=traefik.http.routers.vllm-coding-model.tls.certresolver=route53
Label=traefik.http.services.vllm-coding-model.loadbalancer.server.port=8000
Network=traefik.network
ShmSize=16g
Volume=/mnt/container/models/llm:/opt/models:ro
Volume=/mnt/container/vllm/cache/default:/root/.cache/vllm
Volume=/mnt/container/vllm/cache/triton:/root/.triton/cache

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=nvidia-gpu-0-available.service
After=traefik.service
Description=vLLM Coding Model
Wants=nvidia-gpu-0-available.service
Wants=traefik.service
''
