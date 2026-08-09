{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=immich-machine-learning
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/immich-app/immich-machine-learning:release-cuda
PublishPort=3003:3003
Volume=/mnt/container/immich/machine-learning/ml-dotcache:/.cache
Volume=/mnt/container/immich/machine-learning/ml-dotconfig:/.config
Volume=/mnt/container/immich/machine-learning/model-cache:/cache

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=nvidia-gpu-1-available.service
Description=Immich (Machine Learning)
Wants=nvidia-gpu-1-available.service
''
