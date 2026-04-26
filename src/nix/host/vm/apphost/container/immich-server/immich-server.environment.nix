{ vars, ... }:
''
DB_URL=postgresql://immich:$(cat ${vars.postgresql.immich.password})@postgresql.db.howard.estate:5433/immich?sslmode=require
REDIS_HOSTNAME=immich-valkey
REDIS_PORT=6379
TZ=${vars.timeZone}
''
