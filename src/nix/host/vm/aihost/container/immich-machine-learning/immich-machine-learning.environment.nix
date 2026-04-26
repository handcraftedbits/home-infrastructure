{ ... }:
''
GUNICORN_CMD_ARGS=--worker-class=immich_ml.config.CustomUvicornWorker --worker-tmp-dir=/dev/shm --control-socket=/tmp/gunicorn.ctl
IMMICH_LOG_LEVEL=log
MPLCONFIGDIR=/.config
TZ=America/New_York
''