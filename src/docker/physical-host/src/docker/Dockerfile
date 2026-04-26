FROM infrastructure-runner:latest

COPY opt/container/ /opt/container/
RUN find /opt/container/bin -type f -exec chmod +x {} \;

ENTRYPOINT ["/opt/container/bin/nixos/start-physical-host.sh"]
