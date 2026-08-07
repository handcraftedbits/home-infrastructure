{ vars, ... }:
''
API_URL=http://docsgpt-api:7091
CACHE_REDIS_URL=redis://docsgpt-valkey:6379/2
CELERY_BROKER_URL=redis://docsgpt-valkey:6379/0
CELERY_RESULT_BACKEND=redis://docsgpt-valkey:6379/1
EMBEDDINGS_BASE_URL=http://tei-embedding-model:8080
EMBEDDINGS_NAME=granite-embedding-311m-multilingual-r2
INTERNAL_KEY=some-key
PGVECTOR_CONNECTION_STRING=postgresql://postgres:$(cat ${vars.postgresql.password})@postgresql.db.howard.estate:5432/docsgpt
POSTGRES_URI=postgresql://postgres:$(cat ${vars.postgresql.password})@postgresql.db.howard.estate:5432/docsgpt
VECTOR_STORE=pgvector
''
