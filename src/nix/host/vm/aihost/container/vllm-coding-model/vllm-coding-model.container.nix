{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=0
AutoUpdate=registry
ContainerName=vllm-coding-model
EnvironmentFile=%h/.config/containers/environment/%N
#Exec=/opt/models/RedHatAI/Muse-Glimmer-30B-FP8-block \
Exec=/opt/models/nvidia/Muse-Glimmer-30B-NVFP4 \
  --dtype auto \
  --enable-auto-tool-choice \
  --enable-chunked-prefill \
  --enable-log-requests \
  --enable-prefix-caching \
  --generation-config auto \
  --gpu-memory-utilization 0.73 \
  --host 0.0.0.0 \
  --kv-cache-dtype bfloat16 \
  --max-model-len 131072 \
  --max-num-batched-tokens 8192 \
  --max-num-seqs 8 \
  --port 8000 \
  --reasoning-parser muse_glimmer \
  --served-model-name main \
  --speculative-config '{"method":"dflash","model":"/opt/models/z-lab/Muse-Glimmer-30B-DFlash2","num_speculative_tokens":4}' \
  --tensor-parallel-size 1 \
  --tool-call-parser muse_glimmer
Image=docker.io/vllm/vllm-openai:latest
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
Description=vLLM Coding Model
Wants=nvidia-gpu-0-available.service
''
