{ vars, ... }:
''
ALLOW_CUSTOM_MODEL_PATH=true
LABEL_STUDIO_API_KEY=$(cat ${vars.labelstudio.apiKey})
LABEL_STUDIO_URL=https://labelstudio.app.howard.estate
MODEL_SCORE_THRESHOLD=0.25
''
