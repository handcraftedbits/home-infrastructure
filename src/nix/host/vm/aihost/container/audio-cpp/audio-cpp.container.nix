{ pkgs, ... }:
''
[Container]
AddDevice=nvidia.com/gpu=1
AutoUpdate=registry
ContainerName=audio-cpp
Exec=server --config /opt/config/server.json --log
Image=ghcr.io/0xshug0/audio.cpp:full-cuda12
Label=traefik.enable=true
Label=traefik.http.routers.audiocpp.entrypoints=websecure
Label=traefik.http.routers.audiocpp.rule=Host(`audiocpp.app.howard.estate`)
Label=traefik.http.routers.audiocpp.tls.certresolver=route53
Label=traefik.http.services.audiocpp.loadbalancer.server.port=8080
Network=traefik.network
Volume=/mnt/container/models/audio/audio.cpp:/opt/models:ro
Volume=/mnt/container/audio.cpp/server.json:/opt/config/server.json:ro
Volume=/mnt/container/audio.cpp/voices:/opt/voices:ro

[Install]
WantedBy=default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until [ -e /dev/nvidia1 ] && [ -e /dev/nvidia-modeset ] && [ -e /run/nvidia-persistenced/socket ]; do ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=traefik.service
Description=audio.cpp
''
