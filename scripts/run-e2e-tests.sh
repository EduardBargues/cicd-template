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
logAction "RUNNING E2E TESTS AGAINST"
cat ./app.json
cp ./app.json ./tests/app.json
cd ./tests
npm i
npm run e2e
cd ..