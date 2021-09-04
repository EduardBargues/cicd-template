set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "downloading artifact"
VERSION=$(echo "$1"|tr '/' '-')
log_key_value_pair "version" $VERSION
SERVICE_NAME=$2
log_key_value_pair "service-name" $SERVICE_NAME
BUCKET_NAME=$3
log_key_value_pair "bucket-name" $BUCKET_NAME
IAC=$4
log_key_value_pair "iac" $IAC
DESTINATION_FOLDER=$5
DESTINATION_FOLDER="$WORKING_FOLDER/$DESTINATION_FOLDER"
log_key_value_pair "destination-folder" $DESTINATION_FOLDER

S3_ORIGIN="s3://$BUCKET_NAME/artifacts/$SERVICE_NAME/$VERSION"
log_key_value_pair "s3-origin" $S3_ORIGIN
mkdir -p $DESTINATION_FOLDER
aws s3 cp --recursive $S3_ORIGIN $DESTINATION_FOLDER

REGEX="$DESTINATION_FOLDER/*-$IAC.zip"
log_key_value_pair "iac-regex" $REGEX
for i in $REGEX; do 
    log_action "unzipping iac artifact"
    log_key_value_pair "file" $i
    unzip $i -d $DESTINATION_FOLDER
done

tree $DESTINATION_FOLDER
cd $WORKING_FOLDER