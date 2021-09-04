set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "testing"
TESTS_FOLDER=$1
log_key_value_pair "tests-folder" $TESTS_FOLDER
TESTS_COMMAND=$2
log_key_value_pair "test-command" $TESTS_COMMAND
TESTS_INPUT_FILE=$3
log_key_value_pair "tests-input-file" $TESTS_INPUT_FILE

cp "$WORKING_FOLDER/$TESTS_INPUT_FILE" "$WORKING_FOLDER/$TESTS_FOLDER/app.json"
cd "$WORKING_FOLDER/$TESTS_FOLDER"

npm i
npm run "$TESTS_COMMAND"

cd $WORKING_FOLDER