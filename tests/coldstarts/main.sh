set -e 
WORKING_FOLDER=$(pwd)

log_action() {
    echo "${1^^} ..."
}

log_key_value_pair() {
    echo "    $1: $2"
}

log_action "lamba coldstart analysis"
unset AWS_SESSION_TOKEN

ACCESS_KEY=$1
export AWS_ACCESS_KEY_ID=$ACCESS_KEY
log_key_value_pair "access-key" $ACCESS_KEY

SECRET_KEY=$2
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY

export AWS_REGION=$3
export AWS_DEFAULT_REGION=$AWS_REGION
log_key_value_pair "aws-region" $AWS_REGION

export ITERATIONS=$4
log_key_value_pair "iterations" $ITERATIONS

export MAX_COLDSTART_IN_MS=$5
log_key_value_pair "max-coldstart-in-ms" $MAX_COLDSTART_IN_MS

export LAMBDA_NAME=$6
log_key_value_pair "lambda-name" $LAMBDA_NAME

export PAYLOAD_FILE=$7
log_key_value_pair "payload-file" $PAYLOAD_FILE

cd "$WORKING_FOLDER/tests/coldstarts"
    npm i
    node main.js
cd "$WORKING_FOLDER"