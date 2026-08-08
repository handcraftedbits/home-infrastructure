{ vars, ... }:
''
LABEL_STUDIO_URL=https://labelstudio.app.howard.estate
LABEL_STUDIO_API_KEY=$(cat ${vars.labelstudio.apiKey})
ALLOW_CUSTOM_MODEL_PATH=true
MODEL_SCORE_THRESHOLD=0.25
''
