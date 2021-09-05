const appFile = require("./app.json");

const theApplicationIsUpAndRunning = () => {
  const app = {
    baseUrl: appFile.base_url.value,
    dotnetWebApiEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.dotnet_webapi}`,
    dotnetFunctionEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.dotnet_function}`,
    nodejsFunctionEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.nodejs_function}`,
    // nodejsServerEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.nodejs_server}`,
    pythonFunctionEndpoint: `${appFile.base_url.value}/${appFile.endpoints.value.python_function}`,
  };
  return app;
};

module.exports = { theApplicationIsUpAndRunning };
