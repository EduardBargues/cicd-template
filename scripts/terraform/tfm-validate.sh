set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "validating terraform"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "environment" $SERVICE_NAME
ENVIRONMENT=$3
log_key_value_pair "environment" $ENVIRONMENT
GROUP=$(echo "$4"|tr '/' '-')
log_key_value_pair "service-group" $GROUP
BUCKET_NAME=$5
log_key_value_pair "bucket-name" $BUCKET_NAME

cd $WORKING_FOLDER/terraform

log_action "SETTING UP TERRAFORM BACKEND"
STATE_KEY="infra-states/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfstate"
sed -i "s/replace-me-bucket/$BUCKET_NAME/g" backend.tf
sed -i "s/replace-me-region/$AWS_REGION/g" backend.tf
sed -i "s+replace-me-key+$STATE_KEY+g" backend.tf

terraform init
terraform validate

cd $WORKING_FOLDER