{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=tei-embedding-model
EnvironmentFile=%h/.config/containers/environment/%N
Exec=--auto-truncate false \
  --dtype float16 \
  --hostname 0.0.0.0 \
  --max-batch-tokens 32768 \
  --max-client-batch-size 64 \
  --model-id /opt/models/granite-embedding-311m-multilingual-r2 \
  --pooling cls \
  --port 8080 \
  --served-model-name granite-embedding-311m-multilingual-r2
Image=ghcr.io/huggingface/text-embeddings-inference:86-latest
Network=traefik.network
Volume=/mnt/container/models/llm/ibm-granite/granite-embedding-311m-multilingual-r2:/opt/models/granite-embedding-311m-multilingual-r2

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=nvidia-gpu-1-available.service
Description=TEI Embedding Model
Wants=nvidia-gpu-1-available.service
''
