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
logKeyValuePair "endpoint" $DOTNET_ENDPOINT
dotnet run --project ./tests/performance/Performance.Tests.Console.csproj -- $MAX_AVG_RESPONSE_TIME $THREADS $SECONDS $BASE_URL $DOTNET_ENDPOINT

NODEJS_ENDPOINT=$(jq -r '.nodejs_endpoint.value' ./app.json)
logKeyValuePair "endpoint" $NODEJS_ENDPOINT
dotnet run --project ./tests/performance/Performance.Tests.Console.csproj -- $MAX_AVG_RESPONSE_TIME $THREADS $SECONDS $BASE_URL $NODEJS_ENDPOINT
