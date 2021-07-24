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
logAction "RUNNING PERFORMANCE TESTS"
MAX_AVG_RESPONSE_TIME=$1
logKeyValuePair "max-average-response-time" $MAX_AVG_RESPONSE_TIME
THREADS=$2
logKeyValuePair "number-of-threads" $THREADS
SECONDS=$3
logKeyValuePair "number-of-seconds" $SECONDS
BASE_URL=$(jq -r '.base_url.value' ./app.json)

DOTNET_ENDPOINT=$(jq -r '.dotnet_endpoint.value' ./app.json)
DOTNET_FUNCTION_ENDPOINT=$(jq -r '.dotnet_function_endpoint.value' ./app.json)
NODEJS_ENDPOINT=$(jq -r '.nodejs_endpoint.value' ./app.json)
PYTHON_ENDPOINT=$(jq -r '.python_endpoint.value' ./app.json)
declare -a arr=($DOTNET_ENDPOINT $DOTNET_FUNCTION_ENDPOINT $NODEJS_ENDPOINT $PYTHON_ENDPOINT)
for ENDPOINT in "${arr[@]}"
do
    echo "    ----- -----"
    logKeyValuePair "endpoint" $ENDPOINT
    dotnet run --project ./tests/performance/Performance.Tests.Console.csproj -- $MAX_AVG_RESPONSE_TIME $THREADS $SECONDS $BASE_URL $ENDPOINT
done