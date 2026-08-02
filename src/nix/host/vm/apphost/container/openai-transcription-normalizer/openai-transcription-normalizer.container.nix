{ pkgs, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=openai-transcription-normalizer
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/handcraftedbits/openai-transcription-normalizer:latest
Network=traefik.network

[Install]
WantedBy=default.target openwebui.service

[Service]
ExecStartPre=/bin/sh -c 'until ${pkgs.netcat-openbsd}/bin/nc -z audiocpp.app.howard.estate 443; do echo "Waiting for audio.cpp server..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=openwebui.service traefik.service
BindsTo=openwebui.service
Description=OpenAI Transcription Normalizer
''
