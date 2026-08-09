{ vars, ... }:
''
RCLONE_AUTH_KEY=$(cat ${vars.s3.accessKeyId}),$(cat ${vars.s3.secretAccessKey})
''