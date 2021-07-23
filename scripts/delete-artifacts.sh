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
set -e
source ./scripts/export-environment-variables.sh

export AWS_DEFAULT_REGION=$AWS_REGION
export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY

logAction "GENERAL VARIABLES"
version=$(echo "$1"|tr '/' '-')
logKeyValuePair "version" $version

logAction "DELETING IaC FROM S3 BUCKET"
iacS3Key="$SERVICE_NAME/$version/$SERVICE_NAME-$version-terraform.zip"
logKeyValuePair "iac-s3-key" $iacS3Key
aws s3api delete-object --bucket $BUCKET_NAME --key $iacS3Key || true

logAction "DELETING dotnet Src FROM S3 BUCKET"
srcS3Key="$SERVICE_NAME/$version/$SERVICE_NAME-$version-dotnet.zip"
logKeyValuePair "src-s3-key" $srcS3Key
aws s3api delete-object --bucket $BUCKET_NAME --key $srcS3Key || true

logAction "DELETING nodejs Src FROM S3 BUCKET"
srcS3Key="$SERVICE_NAME/$version/$SERVICE_NAME-$version-nodejs.zip"
logKeyValuePair "src-s3-key" $srcS3Key
aws s3api delete-object --bucket $BUCKET_NAME --key $srcS3Key || true