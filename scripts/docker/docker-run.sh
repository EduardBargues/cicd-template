set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "running docker"
DOCKER_IMAGE_NAME=$1
log_key_value_pair "docker-image-name" $DOCKER_IMAGE_NAME
PORT_NUMBER=$2
log_key_value_pair "port-number" $PORT_NUMBER

docker run -p "$PORTNUMBER:$PORT_NUMBER" $DOCKER_IMAGE_NAME