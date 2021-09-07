const given = require("./given");
const when = require("./when");
const then = require("./then");
const { beforeAll } = require("@jest/globals");

describe(`GIVEN application is up and running`, () => {
  let app;
  beforeAll(() => {
    app = given.theApplicationIsUpAndRunning();
  });

  describe("WHEN calling get - /dotnet-webapi", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.dotnetWebApiEndpoint);
      then.responseIsOk(response);
    });
  });

  describe("WHEN calling /dotnet-function", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.dotnetFunctionEndpoint);
      then.responseIsOk(response);
    });
  });

  describe("WHEN calling /nodejs-function", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.nodejsFunctionEndpoint);
      then.responseIsOk(response);
    });
  });
  describe("WHEN calling /nodejs-server", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.nodejsServerEndpoint);
      then.responseIsOk(response);
    });
  });

  describe("WHEN calling /python-function", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.pythonFunctionEndpoint);
      then.responseIsOk(response);
    });
  });
});
