const given = require("./given");
const when = require("./when");
const then = require("./then");
const { beforeAll } = require("@jest/globals");

describe(`GIVEN application is up and running`, () => {
  let app;
  beforeAll(() => {
    app = given.theApplicationIsUpAndRunning();
  });

  describe("WHEN calling get - /dotnet", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.dotnetEndpoint);
      then.responseIsOk(response);
    });
  });

  describe("WHEN calling /dotnet-function", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.dotnetFunctionEndpoint);
      then.responseIsOk(response);
    });
  });

  describe("WHEN calling /nodejs", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.nodejsEndpoint);
      then.responseIsOk(response);
    });
  });

  describe("WHEN calling /python", () => {
    it(`THEN should return OK-200`, async () => {
      const response = await when.weInvokeEndpoint(app.pythonEndpoint);
      then.responseIsOk(response);
    });
  });
});
