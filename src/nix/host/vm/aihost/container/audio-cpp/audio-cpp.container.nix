{ ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=audio-cpp
Exec=server --config /opt/config/server.json --log
Image=ghcr.io/0xshug0/audio.cpp:full-cuda12
Label=traefik.enable=true
Label=traefik.http.routers.audio-cpp.entrypoints=websecure
Label=traefik.http.routers.audio-cpp.rule=Host(`audiocpp.app.howard.estate`)
Label=traefik.http.routers.audio-cpp.tls.certresolver=route53
Label=traefik.http.services.audio-cpp.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/audio.cpp/server.json:/opt/config/server.json:ro
Volume=/mnt/container/audio.cpp/voices:/opt/voices:ro
Volume=/mnt/container/models/audio/audio.cpp:/opt/models:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=nvidia-gpu-1-available.service
After=traefik.service
Description=audio.cpp
Wants=nvidia-gpu-1-available.service
''
