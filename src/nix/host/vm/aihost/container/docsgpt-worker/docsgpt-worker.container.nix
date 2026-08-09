{ ... }:
''
[Container]
AutoUpdate=registry
ContainerName=docsgpt-worker
Entrypoint=celery
EnvironmentFile=%h/.config/containers/environment/%N
Exec=-A application.app.celery worker -l INFO -B -Q docsgpt,parsing
Image=ghcr.io/arc53/docsgpt:latest
Network=traefik.network
Volume=/mnt/container/docsgpt/indexes:/app/indexes
Volume=/mnt/container/docsgpt/inputs:/app/inputs
Volume=/mnt/container/docsgpt/vectors:/app/vectors

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=docsgpt-api.service
After=mnt-container.mount
After=postgresql-available.service
BindsTo=docsgpt-api.service
Description=DocsGPT (Worker)
Wants=postgresql-available.service
''
