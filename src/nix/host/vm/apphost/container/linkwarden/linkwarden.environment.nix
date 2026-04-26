{ vars, ... }:
''
DATABASE_URL=postgresql://postgres:$(cat ${vars.postgresql.password})@postgresql.db.howard.estate:5432/linkwarden
NEXTAUTH_SECRET=$(cat ${vars.linkwarden.nextauth.password})
NEXTAUTH_URL=https://linkwarden.app.howard.estate/api/v1/auth
''
