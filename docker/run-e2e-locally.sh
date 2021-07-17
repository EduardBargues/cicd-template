set -e 
docker image build . --file ./docker/Dockerfile.e2e.testing --no-cache