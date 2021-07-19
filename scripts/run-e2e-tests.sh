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
logAction "RUNNING E2E TESTS"
cp ./app.json ./tests/app.json
cd ./tests/e2e
npm i
npm run e2e
cd ..
cd ..