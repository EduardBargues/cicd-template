set -e
source ./scripts/export-environment-variables.sh

VERSION=$(echo "$1"|tr '/' '-')
export AWS_DEFAULT_REGION=$AWS_REGION
export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY

declare -a arr=("terraform" "dotnet" "nodejs" "python" "dotnet-function")
for CODE in "${arr[@]}"
do
    aws s3 cp "./$SERVICE_NAME-$VERSION-$CODE.zip" "s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION/$SERVICE_NAME-$VERSION-$CODE.zip"
done