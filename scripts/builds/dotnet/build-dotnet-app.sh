set -e 
WORKING_FOLDER=$(pwd)
source $WORKING_FOLDER/scripts/_common/logging.sh

log_action "building"
SLN_FOLDER=$1
log_key_value_pair "sln-folder" $SLN_FOLDER

REGEX="$WORKING_FOLDER/$SLN_FOLDER/*.sln"
log_key_value_pair "regex" $REGEX
for i in $REGEX; do 
    log_action "building solution (.sln)"
    log_key_value_pair "solution" $i
    dotnet build $i -c Release
done

cd $WORKING_FOLDER