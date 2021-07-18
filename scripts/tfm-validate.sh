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

cd ./terraform

logAction "GENERAL VARIABLES"
VERSION=$(echo "$1"|tr '/' '-')
logKeyValuePair "version" $VERSION
ENVIRONMENT=$2
logKeyValuePair "environment" $ENVIRONMENT
GROUP=$(echo "$3"|tr '/' '-')
logKeyValuePair "service-group" $GROUP

logAction "SETTING UP TERRAFORM BACKEND"
STATE_KEY="infra-states/$ENVIRONMENT/$SERVICE_NAME/$GROUP/$SERVICE_NAME-$ENVIRONMENT-$GROUP.tfstate"
sed -i "s/replace-me-bucket-name/$BUCKET_NAME/g" backend.tf
sed -i "s/replace-me-aws-region/$AWS_REGION/g" backend.tf
sed -i "s+replace-me-tf-state-key+$STATE_KEY+g" backend.tf

terraform init
terraform validate

cd ..