set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "creating dotnet lambda artifact"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "service-name" $SERVICE_NAME
FUNCTION_PROJECT_FOLDER=$3
log_key_value_pair "function-project-folder" $FUNCTION_PROJECT_FOLDER
FUNCTION_NAME=$4
log_key_value_pair "function-project-name" $FUNCTION_NAME
APPLICATION_FRAMEWORK=$5
log_key_value_pair "application-framework" $APPLICATION_FRAMEWORK
BUCKET_NAME=$6
log_key_value_pair "bucket-name" $BUCKET_NAME

FUNCTION_PROJECT_LOCATION="$WORKING_FOLDER/$FUNCTION_PROJECT_FOLDER"
OUTPUT_PACKAGE="./$SERVICE_NAME-$VERSION-$FUNCTION_NAME.zip"
dotnet lambda package \
    -c Release \
    -f $APPLICATION_FRAMEWORK \
    --project-location $FUNCTION_PROJECT_LOCATION \
    --output-package $OUTPUT_PACKAGE

S3_DESTINATION="s3://$BUCKET_NAME/prefix/$SERVICE_NAME/$VERSION/$SERVICE_NAME-$VERSION-$FUNCTION_NAME.zip"
log_key_value_pair "s3-destination" $S3_DESTINATION
aws s3 cp $OUTPUT_PACKAGE $S3_DESTINATION

cd $WORKING_FOLDER