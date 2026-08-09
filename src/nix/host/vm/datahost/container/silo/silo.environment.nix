{ vars, ... }:
''
MINIO_ROOT_PASSWORD=$(cat ${vars.silo.rootPassword})
MINIO_ROOT_USER=curtiss
''
