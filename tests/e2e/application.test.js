const given = require("./given");
const when = require("./when");
const then = require("./then");
const { beforeAll } = require("@jest/globals");

describe(`Given application is up and running`, () => {
  let app;
  beforeAll(() => {
    app = given.theApplicationIsUpAndRunning();
    console.log(`app: ${JSON.stringify(app, null, 4)}`);
  });

  it(`When calling /diagnostics with no version 
  Then should return OK-200`, async () => {
    const response = await when.weInvokeEndpoint(app.diagnosticsEndPoint);
    then.responseIsOk(response);
  });
});
