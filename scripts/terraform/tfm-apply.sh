set -e
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "applying terraform"
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
DEPLOYMENT_FOLDER=$6
log_key_value_pair "deployment-folder" $DEPLOYMENT_FOLDER
OUTPUT_FOLDER=$7
log_key_value_pair "output-folder" $OUTPUT_FOLDER

mkdir "$WORKING_FOLDER/$OUTPUT_FOLDER"
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
sed -i "s/replace-me-lambda_s3_bucket/$BUCKET_NAME/g" terraform.tfvars.json

terraform init
terraform apply -auto-approve

log_action "SETTING INFRASTRUCTURE CONFIGURATION"
confS3Key="s3://$BUCKET_NAME/configurations/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfvars.json"
aws s3 cp terraform.tfvars.json $confS3Key

log_action "WRITTING OUTPUTS IN A JSON"
outputsFile="$WORKING_FOLDER/$OUTPUT_FOLDER/app.json"
log_key_value_pair "output-file" $outputsFile
terraform output -json >> $outputsFile

cd $WORKING_FOLDER