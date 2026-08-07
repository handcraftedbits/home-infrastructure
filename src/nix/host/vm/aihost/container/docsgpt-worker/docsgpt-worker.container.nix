{ pkgs, ... }:
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
WantedBy=docsgpt-api.service default.target

[Service]
ExecStartPre=${pkgs.bash}/bin/bash -c 'until ${pkgs.netcat-openbsd}/bin/nc -z postgresql.db.howard.estate 5432; do echo "Waiting for database..."; ${pkgs.coreutils}/bin/sleep 2; done'
Restart=always
TimeoutStartSec=900

[Unit]
After=docsgpt-api.service mnt-container.mount
BindsTo=docsgpt-api.service
Description=DocsGPT (Worker)
''
