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
logAction "RUNNING MONITORING TESTS"
app_file="$PWD/app.json"
logKeyValuePair "app-file" $app_file
dotnet run --project ./tests/monitoring/Deployment.Monitoring.Tests.Console.csproj -- $app_file 10