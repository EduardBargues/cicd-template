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
logAction "RUNNING PERFORMANCE TESTS AGAINST"
cat ./app.json
cp ./app.json ./tests/app.json
dotnet run --project ./tests/performance/Performance.Tests.Console.csproj
cat ./tests/performance/result.json