{ vars, ... }:
''
CSRF_TRUSTED_ORIGINS=https://labelstudio.app.howard.estate
DJANGO_DB=default
LABEL_STUDIO_ENABLE_LEGACY_API_TOKEN=true
LABEL_STUDIO_HOST=https://labelstudio.app.howard.estate
LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/media
POSTGRE_HOST=postgresql.db.howard.estate
POSTGRE_NAME=labelstudio
POSTGRE_PASSWORD=$(cat ${vars.postgresql.password})
POSTGRE_PORT=5432
POSTGRE_USER=postgres
''
