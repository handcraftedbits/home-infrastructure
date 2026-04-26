{ vars, ... }:
''
AWS_ACCESS_KEY_ID=$(cat ${vars.aws.accessKeyId})
AWS_REGION=${vars.aws.region}
AWS_SECRET_ACCESS_KEY=$(cat ${vars.aws.secretAccessKey})
TZ=${vars.timeZone}
''
