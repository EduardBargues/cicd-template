set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "validating cloudformation"
CFN_TEMPLATE=$1
log_key_value_pair "cfn-template" $CFN_TEMPLATE
aws cloudformation validate-template --template-body "file://$WORKING_FOLDER/$CFN_TEMPLATE" --region $AWS_DEFAULT_REGION

cd $WORKING_FOLDER