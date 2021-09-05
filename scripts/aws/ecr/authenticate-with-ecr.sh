set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "authenticating with ecr"
AWS_REGION=$1
log_key_value_pair "aws-region" $AWS_REGION
AWS_ACCOUNT_ID=$2
log_key_value_pair "aws-account-id" $AWS_ACCOUNT_ID

aws ecr get-login-password \
    --region $AWS_REGION \
| docker login \
    --username AWS \
    --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"