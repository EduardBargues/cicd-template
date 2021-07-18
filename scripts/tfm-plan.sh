set -e

cd ./terraform

cp terraform.tfvars.json.template terraform.tfvars.json
terraform init
terraform plan
rm terraform.tfvars.json

cd ..