set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "removing untagged images from ecr"
REPOSITORY_NAME=$1
log_key_value_pair "repository-name" $REPOSITORY_NAME
AWS_REGION=$2
log_key_value_pair "aws-region" $AWS_REGION

IMAGES_TO_DELETE=$( aws ecr list-images --region $AWS_REGION --repository-name $REPOSITORY_NAME --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json )
aws ecr batch-delete-image --region $AWS_REGION --repository-name $REPOSITORY_NAME --image-ids "$IMAGES_TO_DELETE" || true
