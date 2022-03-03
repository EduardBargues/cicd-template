const appFile = require("./app.json");

const theApplicationIsUpAndRunning = () => {
  const app = {
    dotnetWebApiEndpoint: appFile.endpoints.value._dotnet_webapi,
    dotnetFunctionEndpoint: appFile.endpoints.value._dotnet_function,
    dotnet6FunctionEndpoint: appFile.endpoints.value._dotnet6_function,
    nodejsFunctionEndpoint: appFile.endpoints.value._nodejs_function,
    nodejsServerEndpoint: appFile.endpoints.value._nodejs_server,
    pythonFunctionEndpoint: appFile.endpoints.value._python_function,
  };
  return app;
};

module.exports = { theApplicationIsUpAndRunning };
