{ vars, ... }:
''
[Container]
AutoUpdate=registry
ContainerName=traefik
EnvironmentFile=%h/.config/containers/environment/%N
Exec=\
  --certificatesresolvers.route53.acme.dnschallenge=true \
  --certificatesresolvers.route53.acme.dnschallenge.provider=route53 \
  --certificatesresolvers.route53.acme.dnschallenge.delayBeforeCheck=0 \
  --certificatesresolvers.route53.acme.dnschallenge.resolvers=8.8.8.8:53 \
  --certificatesresolvers.route53.acme.email=${vars.acme.email} \
  --certificatesresolvers.route53.acme.storage=/certs/acme.json \
  --entrypoints.web.address=:80 \
  --entrypoints.web.http.redirections.entryPoint.to=websecure \
  --entrypoints.web.http.redirections.entryPoint.permanent=true \
  --entrypoints.web.http.redirections.entryPoint.scheme=https \
  --entrypoints.websecure.address=:443 \
  --log.level=INFO \
  --providers.docker=true \
  --providers.docker.exposedbydefault=false
Image=docker.io/library/traefik:latest
Network=traefik.network
PublishPort=80:80
PublishPort=443:443
Volume=/mnt/container/traefik/certs:/certs
Volume=%t/podman/podman.sock:/var/run/docker.sock:ro

[Install]
WantedBy=default.target

[Service]
Restart=always
TimeoutStartSec=900

[Unit]
After=mnt-container.mount
After=podman.socket
After=traefik-network.service
BindsTo=podman.socket
Description=Traefik
Requires=traefik-network.service
''
