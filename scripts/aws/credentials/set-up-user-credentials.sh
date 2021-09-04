set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "setting up user credentials"
unset AWS_SESSION_TOKEN

export AWS_DEFAULT_REGION=$1
log_key_value_pair "aws-default-region" $AWS_DEFAULT_REGION
export AWS_ACCESS_KEY_ID=$2
log_key_value_pair "aws-access-key-id" $AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$3
log_key_value_pair "aws-secret-access-key" $AWS_SECRET_ACCESS_KEY

cd $WORKING_FOLDER