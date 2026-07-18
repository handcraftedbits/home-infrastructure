{ vars, ... }:
''
DB_HOST=postgresql.db.howard.estate
DB_NAME=romm
DB_PASSWD=$(cat ${vars.postgresql.password})
DB_PORT=5432
DB_USER=postgres
ENABLE_SCHEDULED_UPDATE_LAUNCHBOX_METADATA=true
HASHEOUS_API_ENABLED=true
LAUNCHBOX_API_ENABLED=true
PLAYMATCH_API_ENABLED=true
ROMM_AUTH_SECRET_KEY=$(cat ${vars.romm.secretKey})
ROMM_DB_DRIVER=postgresql
''
