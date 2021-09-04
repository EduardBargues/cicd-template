set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "uploading lambda artifact to s3"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "service-name" $SERVICE_NAME
FUNCTION_PROJECT_NAME=$3
log_key_value_pair "function-project-name" $FUNCTION_PROJECT_NAME
ARTIFACT_FOLDER=$4
log_key_value_pair "artifact-path" $ARTIFACT_FOLDER
BUCKET_NAME=$5
log_key_value_pair "bucket-name" $BUCKET_NAME

ARTIFACT_PATH="$WORKING_FOLDER/$ARTIFACT_FOLDER/$SERVICE_NAME-$VERSION-$FUNCTION_PROJECT_NAME.zip"
S3_DESTINATION="s3://$BUCKET_NAME/$SERVICE_NAME/$VERSION/$SERVICE_NAME-$VERSION-$FUNCTION_PROJECT_NAME.zip"
log_key_value_pair "s3-destination" $S3_DESTINATION
aws s3 cp $ARTIFACT_PATH $S3_DESTINATION