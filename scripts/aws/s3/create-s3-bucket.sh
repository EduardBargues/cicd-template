set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "creating s3 bucket"
S3_BUCKET_NAME=$1
log_key_value_pair "s3-bucket" $S3_BUCKET_NAME
log_key_value_pair "aws-default-region" $AWS_DEFAULT_REGION
aws s3api create-bucket \
    --bucket $S3_BUCKET_NAME \
    --region $AWS_DEFAULT_REGION \
    --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION \
    || true

cd $WORKING_FOLDER