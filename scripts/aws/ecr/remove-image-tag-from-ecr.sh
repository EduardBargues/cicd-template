set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "removing image tag from ecr"
REPOSITORY_NAME=$1
log_key_value_pair "repository-name" $REPOSITORY_NAME
TAG=$(echo "$2"|tr '/' '-')
log_key_value_pair "tag" $TAG
AWS_REGION=$3
log_key_value_pair "aws-region" $AWS_REGION

aws ecr batch-delete-image \
    --repository-name $REPOSITORY_NAME \
    --image-ids imageTag=$TAG
    
IMAGES_TO_DELETE=$( aws ecr list-images --region $AWS_REGION --repository-name $REPOSITORY_NAME --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json )
aws ecr batch-delete-image --region $ECR_REGION --repository-name $ECR_REPO --image-ids "$IMAGES_TO_DELETE" || true
