const appFile = require("../app.json");

const theApplicationIsUpAndRunning = () => {
  const app = {
    baseUrl: appFile.base_url.value,
    dotnetEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.dotnet_endpoint}`,
    dotnetFunctionEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.dotnet_function_endpoint}`,
    nodejsEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.nodejs_endpoint}`,
    pythonEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.python_endpoint}`,
  };
  return app;
};

module.exports = { theApplicationIsUpAndRunning };
