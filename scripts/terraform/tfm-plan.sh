set -e
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "planning terraform"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "environment" $SERVICE_NAME
ENVIRONMENT=$3
log_key_value_pair "environment" $ENVIRONMENT
GROUP=$(echo "$4"|tr '/' '-')
log_key_value_pair "service-group" $GROUP
ECR_NAME=$5
log_key_value_pair "ecr-name" $ECR_NAME
DOCKER_IMAGE_TAG=$(echo "$6"|tr '/' '-')
log_key_value_pair "docker-image-tag" $DOCKER_IMAGE_TAG
BUCKET_NAME=$7
log_key_value_pair "bucket-name" $BUCKET_NAME
DEPLOYMENT_FOLDER=$8
log_key_value_pair "deployment-folder" $DEPLOYMENT_FOLDER

cd $WORKING_FOLDER/$DEPLOYMENT_FOLDER/terraform

log_action "SETTING UP TERRAFORM BACKEND"
STATE_KEY="infra-states/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfstate"
sed -i "s/replace-me-bucket-name/$BUCKET_NAME/g" backend.tf
sed -i "s/replace-me-aws-region/$AWS_REGION/g" backend.tf
sed -i "s+replace-me-tf-state-key+$STATE_KEY+g" backend.tf

log_action "SETTING UP TERRAFORM VARIABLES"
cp terraform.tfvars.json.template terraform.tfvars.json
sed -i "s/replace-me-service_name/$SERVICE_NAME/g" terraform.tfvars.json
sed -i "s/replace-me-service_version/$VERSION/g" terraform.tfvars.json
sed -i "s/replace-me-service_group/$GROUP/g" terraform.tfvars.json
sed -i "s/replace-me-environment/$ENVIRONMENT/g" terraform.tfvars.json
sed -i "s/replace-me-aws_region/$AWS_REGION/g" terraform.tfvars.json
sed -i "s/replace-me-aws_account_id/$AWS_ACCOUNT_ID/g" terraform.tfvars.json
sed -i "s/replace-me-ecr_name/lucky-edu-ecr/g" terraform.tfvars.json
sed -i "s/replace-me-docker_image_tag/$DOCKER_IMAGE_TAG/g" terraform.tfvars.json
sed -i "s/replace-me-lambda_s3_bucket/$BUCKET_NAME/g" terraform.tfvars.json

terraform init
terraform plan
rm terraform.tfvars.json

cd $WORKING_FOLDER