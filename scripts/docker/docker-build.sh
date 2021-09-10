set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "building docker"
DOCKERFILE_NAME=$1
log_key_value_pair "dockerfile-name" $DOCKERFILE_NAME
TAG=$2
log_key_value_pair "tag" $TAG

docker image build . \
    --file $DOCKERFILE_NAME \
    --tag $TAG