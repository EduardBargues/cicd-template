docker-compose up -d localstack
docker-compose run terraform init
docker-compose run terraform apply --auto-approve