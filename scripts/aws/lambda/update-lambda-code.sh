###############
## FUNCTIONS ##
###############
logKeyValuePair()
{
    echo "    $1: $2"
}
logAction()
{
    echo ""
    echo "$1 ..."
}

############
## SCRIPT ##
############
set -e
source ./scripts/export-aws-credentials.sh

logAction "UPDATING LAMBDA CODE"
LAMBDA_NAME=$1
logKeyValuePair "lambda-name" $LAMBDA_NAME
ARTIFACT=$2
logKeyValuePair "artifact" $ARTIFACT

aws lambda update-function-code --function-name $LAMBDA_NAME --zip-file "fileb://$ARTIFACT"