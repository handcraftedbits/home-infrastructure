{ vars, ... }:
''
POSTGRES_PASSWORD=$(cat ${vars.postgresql.password})
POSTGRES_USER=postgres
''
