{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=openai-transcription-normalizer
EnvironmentFile=%h/.config/containers/environment/%N
Image=ghcr.io/handcraftedbits/openai-transcription-normalizer:latest
Network=traefik.network

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=audio-cpp-available.service
After=openchamber.service
After=traefik.service
Description=OpenAI Transcription Normalizer
Wants=audio-cpp-available.service
''
