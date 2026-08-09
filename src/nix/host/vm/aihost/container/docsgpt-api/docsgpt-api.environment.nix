{ vars, ... }:
''
API_KEY=none
CACHE_REDIS_URL=redis://docsgpt-valkey:6379/2
CELERY_BROKER_URL=redis://docsgpt-valkey:6379/0
CELERY_RESULT_BACKEND=redis://docsgpt-valkey:6379/1
EMBEDDINGS_BASE_URL=http://tei-embedding-model:8080
EMBEDDINGS_NAME=granite-embedding-311m-multilingual-r2
INTERNAL_KEY=some-key
LLM_NAME=task/gemma4-e4b
LLM_PROVIDER=openai
OPENAI_API_KEY=some-key
OPENAI_BASE_URL=http://llama-task-model:8080/v1
PGVECTOR_CONNECTION_STRING=postgresql://postgres:$(cat ${vars.postgresql.password})@postgresql.db.howard.estate:5432/docsgpt
POSTGRES_URI=postgresql://postgres:$(cat ${vars.postgresql.password})@postgresql.db.howard.estate:5432/docsgpt
VECTOR_STORE=pgvector
''
