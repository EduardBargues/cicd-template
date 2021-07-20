###############
## FUNCTIONS ##
###############
logKeyValuePair()
{
    echo "    $1: $2"
}
logAction()
{
    echo ""
    echo "$1 ..."
}

############
## SCRIPT ##
############
source ./scripts/export-environment-variables.sh

set -e
export AWS_DEFAULT_REGION=$AWS_REGION
export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY

logAction "GENERAL VARIABLES"
VERSION=$(jq -r '.version' ./configuration/conf.json)
logKeyValuePair "version" $VERSION
ENVIRONMENT=$(jq -r '.environment' ./configuration/conf.json)
logKeyValuePair "environment" $ENVIRONMENT
GROUP=$(jq -r '.serviceGroup' ./configuration/conf.json)
logKeyValuePair "service-group" $GROUP

logAction "DOWNLOADING IaC FROM S3 BUCKET"
iacFileName="terraform-$SERVICE_NAME-$VERSION.zip"
iacS3Origin="s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION/$iacFileName"
deploymentFolder="deployment-$(date "+%Y-%m-%d--%H-%M-%S")"
mkdir $deploymentFolder
iacDestinationPath="./$deploymentFolder"
aws s3 cp $iacS3Origin $iacDestinationPath

logAction "UNZIPPING IaC FILE"
unzip "./$deploymentFolder/$iacFileName" -d "./$deploymentFolder"

logAction "ENTERING IaC FOLDER FOR DEPLOYMENT"
tfmFolder="./$deploymentFolder/terraform"
cd $tfmFolder

logAction "SETTING UP TERRAFORM BACKEND"
STATE_KEY="infra-states/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfstate"
sed -i "s/replace-me-bucket-name/$BUCKET_NAME/g" backend.tf
sed -i "s/replace-me-aws-region/$AWS_REGION/g" backend.tf
sed -i "s+replace-me-tf-state-key+$STATE_KEY+g" backend.tf

logAction "SETTING UP TERRAFORM VARIABLES"
tfvars="terraform.tfvars.json"
confS3Key="s3://$BUCKET_NAME/configurations/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfvars.json"
aws s3 cp $confS3Key $tfvars

logAction "PLANNING"
terraform init
terraform apply -auto-approve