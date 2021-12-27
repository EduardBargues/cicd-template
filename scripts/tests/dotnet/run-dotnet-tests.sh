set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "testing"
FOLDER=$1
log_key_value_pair "folder" $FOLDER
EXTENSION=$2
log_key_value_pair "extension-file" $EXTENSION

REGEX="$WORKING_FOLDER/$FOLDER/*.$EXTENSION"
log_key_value_pair "regex" $REGEX
for i in $REGEX; do 
    log_action "testing (.$EXTENSION)"
    log_key_value_pair "file" $i
    dotnet test $i -c Release
done

cd $WORKING_FOLDER