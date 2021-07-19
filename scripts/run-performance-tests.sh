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
# logKeyValuePair "base-url" $BASE_URL
DIAGNOSTICS_ENDPOINT=$(jq -r '.diagnostics_endpoint.value' ./app.json)
# logKeyValuePair "diagnostics-url" $DIAGNOSTICS_ENDPOINT

dotnet run --project ./tests/performance/Performance.Tests.Console.csproj -- $MAX_AVG_RESPONSE_TIME $THREADS $SECONDS $BASE_URL $DIAGNOSTICS_ENDPOINT