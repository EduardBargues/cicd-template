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
logError()
{
    echo ""
    echo "    ERROR => $1"
}

############
## SCRIPT ##
############
set -e
logAction "RUNNING COLD START TESTS"
MAX_RESPONSE_TIME=$1
logKeyValuePair "max-response-time" $MAX_RESPONSE_TIME
BASE_URL=$(jq -r '.base_url.value' ./app.json)

DOTNET_ENDPOINT=$(jq -r '.endpoints.value.dotnet_endpoint' ./app.json)
DOTNET_FUNCTION_ENDPOINT=$(jq -r '.endpoints.value.dotnet_function_endpoint' ./app.json)
NODEJS_ENDPOINT=$(jq -r '.endpoints.value.nodejs_endpoint' ./app.json)
PYTHON_ENDPOINT=$(jq -r '.endpoints.value.python_endpoint' ./app.json)
declare -a arr=($DOTNET_ENDPOINT $DOTNET_FUNCTION_ENDPOINT $NODEJS_ENDPOINT $PYTHON_ENDPOINT)
for ENDPOINT in "${arr[@]}"
do
    echo "    ----- -----"
    logKeyValuePair "endpoint" $ENDPOINT
    dotnet run --project ./tests/performance/first-call/Performance.FirstCall.Tests.Console.csproj -- $MAX_RESPONSE_TIME $BASE_URL $ENDPOINT
done