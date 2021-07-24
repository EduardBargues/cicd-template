const appFile = require("../app.json");

const theApplicationIsUpAndRunning = () => {
  const app = {
    baseUrl: appFile.base_url.value,
    dotnetEndpoint: `${appFile.base_url.value}/${appFile.dotnet_endpoint.value}`,
    nodejsEndpoint: `${appFile.base_url.value}/${appFile.nodejs_endpoint.value}`,
    pythonEndpoint: `${appFile.base_url.value}/${appFile.python_endpoint.value}`,
  };
  return app;
};

module.exports = { theApplicationIsUpAndRunning };
