{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=labelstudio-ml-backend
EnvironmentFile=%h/.config/containers/environment/%N
Image=docker.io/heartexlabs/label-studio-ml-backend:yolo-master
Network=traefik.network
Volume=/mnt/container/models/vision:/app/models:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=labelstudio.service
After=mnt-container.mount
After=nvidia-gpu-1-available.service
After=traefik.service
BindsTo=labelstudio.service
Description=Label Studio (ML Backend)
Wants=nvidia-gpu-1-available.service
''
