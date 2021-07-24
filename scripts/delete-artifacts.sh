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

declare -a arr=("terraform" "dotnet" "nodejs" "python")
for CODE in "${arr[@]}"
do
    logAction "DELETING ARTIFACTS FROM S3 BUCKET"
    s3Key="artifacts/$SERVICE_NAME/$version/$SERVICE_NAME-$version-$CODE.zip"
    logKeyValuePair "iac-s3-key" $s3Key
    aws s3api delete-object --bucket $BUCKET_NAME --key $s3Key || true
done