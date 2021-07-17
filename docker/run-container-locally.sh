set -e 
docker image build . --file ./docker/Dockerfile.create.artifact --tag api
docker run -p 5000:5000 api