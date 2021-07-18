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
VERSION=$(echo "$1"|tr '/' '-')
logKeyValuePair "version" $VERSION
ENVIRONMENT=$2
logKeyValuePair "environment" $ENVIRONMENT
GROUP=$(echo "$3"|tr '/' '-')
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

logAction "DOWNLOADING SOURCE ARTIFACT FROM S3 BUCKET"
srcFileName="$SERVICE_NAME-$VERSION.zip"
srcS3Origin="s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION/$srcFileName"
srcDestinationPath="./$deploymentFolder"
aws s3 cp $srcS3Origin $srcDestinationPath

logAction "ENTERING IaC FOLDER FOR DEPLOYMENT"
tfmFolder="./$deploymentFolder/terraform"
cd $tfmFolder

logAction "SETTING UP TERRAFORM BACKEND"
STATE_KEY="infra-states/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfstate"
sed -i "s/replace-me-bucket-name/$BUCKET_NAME/g" backend.tf
sed -i "s/replace-me-aws-region/$AWS_REGION/g" backend.tf
sed -i "s+replace-me-tf-state-key+$STATE_KEY+g" backend.tf
cat backend.tf

logAction "SETTING UP TERRAFORM VARIABLES"
tfvars="terraform.tfvars.json"
cp terraform.tfvars.json.template $tfvars
sed -i "s/replace-me-service_name/$SERVICE_NAME/g" $tfvars
sed -i "s/replace-me-service_version/$VERSION/g" $tfvars
sed -i "s/replace-me-service_group/$GROUP/g" $tfvars
sed -i "s/replace-me-environment/$ENVIRONMENT/g" $tfvars
sed -i "s/replace-me-destination_account_id/$AWS_ACCOUNT_ID/g" $tfvars
sed -i "s/replace-me-aws_region/$AWS_REGION/g" $tfvars
sed -i "s/replace-me-deployment_role_name/$DEPLOYMENTS_ROLE_NAME/g" $tfvars

logAction "DEPLOYING"
terraform init
terraform apply -auto-approve

logAction "SETTING INFRASTRUCTURE CONFIGURATION"
confS3Key="s3://$BUCKET_NAME/configurations/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfvars.json"
aws s3 cp $tfvars $confS3Key

# logAction "WRITTING OUTPUTS IN A JSON"
# outputsFile="terraform.outputs.json"
# logKeyValuePair "output-file" $outputsFile
# terraform output -json >> $outputsFile
# cat $outputsFile