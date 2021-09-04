set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "creating nodejs lambda artifact"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "service-name" $SERVICE_NAME
FUNCTION_PROJECT_FOLDER=$3
log_key_value_pair "function-project-folder" $FUNCTION_PROJECT_FOLDER
BUCKET_NAME=$4
log_key_value_pair "bucket-name" $BUCKET_NAME

cd $WORKING_FOLDER/$FUNCTION_PROJECT_FOLDER
npm install
npm run pack
S3_DESTINATION="s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION/$SERVICE_NAME-$VERSION-nodejs.zip"
log_key_value_pair "s3-destination" $S3_DESTINATION
aws s3 cp nodejs-lambda.zip $S3_DESTINATION

cd $WORKING_FOLDER