set -e
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "deleting artifacts"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "service-name" $SERVICE_NAME
BUCKET_NAME=$3
log_key_value_pair "bucket-name" $BUCKET_NAME

aws s3 rm "s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION" --recursive