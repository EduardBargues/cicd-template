set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "building docker"
DOCKERFILE_NAME=$1
log_key_value_pair "dockerfile-name" $DOCKERFILE_NAME
DOCKER_REPOSITORY_NAME=$2
log_key_value_pair "docker-repository-name" $DOCKER_REPOSITORY_NAME

docker image build . \
    --file $DOCKERFILE_NAME \
    --tag $DOCKER_REPOSITORY_NAME