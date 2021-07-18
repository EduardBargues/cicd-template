set -e

cd ./terraform

terraform init
terraform validate

cd ..