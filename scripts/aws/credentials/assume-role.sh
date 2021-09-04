set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "assuming role"
AWS_ACCOUNT_ID=$1
log_key_value_pair "aws-account-id" $AWS_ACCOUNT_ID
ROLE_NAME=$2
log_key_value_pair "role-name" $ROLE_NAME
ROLE_ARN="arn:aws:iam::$AWS_ACCOUNT_ID:role/$ROLE_NAME"
log_key_value_pair "role-arn" $ROLE_ARN

CREDENTIALS_FILE_NAME="aws-credentials.json"
aws sts assume-role --role-arn $ROLE_ARN --role-session-name github-session >> $CREDENTIALS_FILE_NAME

export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' $CREDENTIALS_FILE_NAME)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' $CREDENTIALS_FILE_NAME)
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' $CREDENTIALS_FILE_NAME)

cd $WORKING_FOLDER