set -e 
source ./scripts/export-environment-variables.sh

VERSION=$(echo "$1"|tr '/' '-')

zip -r "./$SERVICE_NAME-$VERSION-terraform.zip" ./terraform

dotnet lambda package -c Release -f $APP_FRAMEWORK --project-location ./src/dotnet/$WEB_API_PROJECT_NAME --output-package ./$SERVICE_NAME-$VERSION-dotnet.zip
dotnet lambda package -c Release -f $APP_FRAMEWORK --project-location ./src/dotnet/$FUNCTION_PROJECT_NAME --output-package ./$SERVICE_NAME-$VERSION-dotnet-function.zip

cd ./src/nodejs
npm install
npm run pack
cp nodejs-lambda.zip ../../$SERVICE_NAME-$VERSION-nodejs.zip
cd ..
cd ..

cd ./src/python
zip python.zip main.py
cp python.zip ../../$SERVICE_NAME-$VERSION-python.zip
cd .. 
cd ..