const given = require("./given");
const when = require("./when");
const then = require("./then");
const { beforeAll } = require("@jest/globals");

describe(`Given application is up and running`, () => {
  let app;
  beforeAll(() => {
    app = given.theApplicationIsUpAndRunning();
  });

  it(`When calling /dotnet 
      Then should return OK-200`, async () => {
    const response = await when.weInvokeEndpoint(app.dotnetEndpoint);
    then.responseIsOk(response);
  });

  it(`When calling /nodejs 
      Then should return OK-200`, async () => {
    const response = await when.weInvokeEndpoint(app.nodejsEndpoint);
    then.responseIsOk(response);
  });

  it(`When calling /python 
      Then should return OK-200`, async () => {
    const response = await when.weInvokeEndpoint(app.pythonEndpoint);
    then.responseIsOk(response);
  });
});
