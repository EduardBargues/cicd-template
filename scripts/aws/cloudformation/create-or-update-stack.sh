set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "deploying cloudformation stack"
STACK_NAME=$1
log_key_value_pair "stack-name" $STACK_NAME
TEMPLATE_BODY_PATH=$2
log_key_value_pair "template-body-path" $TEMPLATE_BODY_PATH
TEMPLATE_BODY="$WORKING_FOLDER/$TEMPLATE_BODY_PATH"
# cat $TEMPLATE_BODY
CFN_PARAMETERS_PATH=$3
log_key_value_pair "cfn-parameters-path" $CFN_PARAMETERS_PATH
CFN_PARAMETERS_FILE="$WORKING_FOLDER/$CFN_PARAMETERS_PATH"
cat $CFN_PARAMETERS_FILE

STACK=$(aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r '.Stacks[0]')
STACK_FILE="stack-file.json"
if [ -z "$STACK" ]; 
then
    log_action "creating stack"
    aws cloudformation create-stack \
        --stack-name $STACK_NAME \
        --template-body "file://$TEMPLATE_BODY" \
        --parameters "file://$CFN_PARAMETERS_FILE" \
        --capabilities "CAPABILITY_NAMED_IAM" >> $STACK_FILE
    STACK_ARN=$(jq -r '.StackId' $STACK_FILE)
    log_key_value_pair "stack-arn" $STACK_ARN
    aws cloudformation wait stack-create-complete \
        --stack-name $STACK_ARN
else
    log_action "updating stack"
    aws cloudformation update-stack \
        --stack-name $STACK_NAME \
        --template-body "file://$TEMPLATE_BODY" \
        --parameters "file://$CFN_PARAMETERS_FILE" \
        --capabilities "CAPABILITY_NAMED_IAM" >> $STACK_FILE
    STACK_ARN=$(jq -r '.StackId' $STACK_FILE)
    log_key_value_pair "stack-arn" $STACK_ARN
    aws cloudformation wait stack-update-complete \
        --stack-name $STACK_ARN
fi