set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "tagging docker"
SERVICE_NAME=$1
log_key_value_pair "service-name" $SERVICE_NAME
VERSION=$(echo "$2"|tr '/' '-')
log_key_value_pair "version" $VERSION
AWS_REGION=$3
log_key_value_pair "aws-region" $AWS_REGION
AWS_ACCOUNT_ID=$4
log_key_value_pair "aws-account-id" $AWS_ACCOUNT_ID

docker tag "$SERVICE_NAME" "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVICE_NAME:$VERSION"