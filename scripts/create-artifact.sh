source ./scripts/export-environment-variables.sh

VERSION=$(echo "$1"|tr '/' '-')
zip -r "./terraform-$SERVICE_NAME-$VERSION.zip" ./terraform
dotnet lambda package -c Release -f $APP_FRAMEWORK --project-location ./src/$WEB_API_PROJECT_NAME --output-package ./$SERVICE_NAME-$VERSION.zip