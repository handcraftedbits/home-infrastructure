{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=0
AutoUpdate=registry
ContainerName=vllm-coding-agent
EnvironmentFile=%h/.config/containers/environment/%N
Exec= /opt/models/Qwen3.6-27B-FP8 \
  --attention-backend flashinfer \
  --dtype auto \
  --enable-auto-tool-choice \
  --enable-chunked-prefill \
  --enable-log-requests \
  --enable-prefix-caching \
  --gpu-memory-utilization 0.80 \
  --host 0.0.0.0 \
  --kv-cache-dtype bfloat16 \
  --max-model-len 262144 \
  --port 8000 \
  --reasoning-parser qwen3 \
  --served-model-name qwen3.6-27b \
  --speculative-config '{"method":"mtp","num_speculative_tokens":2}' \
  --tensor-parallel-size 1 \
  --tool-call-parser qwen3_coder
Image=docker.io/vllm/vllm-openai:latest
Label=traefik.enable=true
Label=traefik.http.routers.vllmcodingagent.entrypoints=websecure
Label=traefik.http.routers.vllmcodingagent.rule=Host(`coding.llm.howard.estate`)
Label=traefik.http.routers.vllmcodingagent.tls.certresolver=route53
Label=traefik.http.services.vllmcodingagent.loadbalancer.server.port=8000
Network=traefik.network
ShmSize=16g
Volume=/mnt/container/models/llm:/opt/models
Volume=/mnt/container/vllm/cache/default:/root/.cache/vllm
Volume=/mnt/container/vllm/cache/triton:/root/.triton/cache

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia0 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=vLLM Coding Agent
''
