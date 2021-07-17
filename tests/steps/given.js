const appFile = require("../app.json");

const theApplicationIsUpAndRunning = () => {
  const app = {
    baseUrl: appFile.base_url.value,
    diagnosticsEndPoint: `${appFile.base_url.value}/${appFile.diagnostics_endpoint.value}`,
  };
  return app;
};

module.exports = { theApplicationIsUpAndRunning };
