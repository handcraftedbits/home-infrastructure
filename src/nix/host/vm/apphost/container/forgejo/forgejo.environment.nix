{ vars, ... }:
''
FORGEJO__database__DB_TYPE=postgres
FORGEJO__database__HOST=postgresql.db.howard.estate:5432
FORGEJO__database__NAME=forgejo
FORGEJO__database__PASSWD=$(cat ${vars.postgresql.password})
FORGEJO__database__USER=postgres
SSH_PORT=2222
''
