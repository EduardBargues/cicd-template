# check out dashboard here => http://localhost:3000/d/k6/k6-load-testing-results
./scripts/docker/docker-build.sh \
    dockerfile.create-dotnet-webapi-image \
    dotnet-webapi
./scripts/docker/docker-build.sh \
    dockerfile.create-nodejs-server-image \
    nodejs-server
docker-compose up -d influxdb grafana dotnet-webapi nodejs-server
docker-compose run --rm k6 run /scripts/local-performance-tests.js