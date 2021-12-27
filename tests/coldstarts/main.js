const AWS = require("aws-sdk");
const fs = require("fs");
const { mean, min, max, std, median } = require("mathjs");
const { exit } = require("process");

// CONSTANTS
const now = new Date();
const ENV_VAR_NAME = `ENV_VAR_${now.getUTCFullYear()}_${now.getUTCMonth()}_${now.getUTCDay()}`;

// INPUTS
const iterations = process.env.ITERATIONS;
const maxColdstart = process.env.MAX_COLDSTART_IN_MS;
const lambdaName = process.env.LAMBDA_NAME;
const payloadFile = process.env.PAYLOAD_FILE;
const payload = fs.readFileSync(payloadFile);
const awsRegion = process.env.AWS_REGION;
const lambda = new AWS.Lambda({ region: awsRegion });

// FUNCTIONS
const log = (key, value) =>
  console.log(`    ${key}: ${JSON.stringify(value, null, 2)}`);
const snooze = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const doWithRetries = async (func, operationName) => {
  const MAX_RETRIES = 3;
  for (let retry = 1; retry <= MAX_RETRIES; retry++) {
    const start = new Date();
    let result = {};
    let error = null;
    try {
      result = await func();
    } catch (err) {
      error = err;
    }
    const stop = new Date();
    if (!error) return { result, span: stop - start };
    else {
      console.log(
        `    ${operationName} failed. retrying in 500 ms ... retry: ${retry}/${MAX_RETRIES}`
      );
      await snooze(500);
    }
  }
};
const getLambdaEnvironment = () => {
  return new Promise((resolve, reject) => {
    lambda.getFunctionConfiguration(
      { FunctionName: lambdaName },
      (error, data) => {
        if (error) reject(error);
        else {
          if (!data.Environment) data.Environment = { Variables: {} };
          resolve(data.Environment);
        }
      }
    );
  });
};
const setLambdaEnvironment = (environment) => {
  return new Promise((resolve, reject) => {
    lambda.updateFunctionConfiguration(
      {
        FunctionName: lambdaName,
        Environment: environment,
      },
      (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data.Environment);
        }
      }
    );
  });
};
const invokeLambda = () =>
  new Promise((resolve, reject) => {
    lambda.invoke(
      { FunctionName: lambdaName, Payload: payload },
      (error, data) => {
        if (error) {
          reject(error);
        } else {
          resolve(data);
        }
      }
    );
  });

// SCRIPT
const main = async () => {
  let times = []; // ms

  let environment = await getLambdaEnvironment();

  for (let iter = 1; iter <= iterations; iter++) {
    environment.Variables[ENV_VAR_NAME] = `${iter}`;
    await doWithRetries(
      async () => await setLambdaEnvironment(environment),
      "set-lambda-environment"
    );
    const result = await doWithRetries(invokeLambda, "invoke-lambda");
    console.log(`iteration: ${iter}/${iterations} - ms: ${result.span}`);
    times.push(result.span);
  }

  delete environment.Variables[ENV_VAR_NAME];
  await doWithRetries(
    async () => await setLambdaEnvironment(environment),
    "set-lambda-environment"
  );

  log("  count", times.length);
  const average = mean(times);
  log("average", average);
  log("minimum", min(times));
  log("maximum", max(times));
  log("    std", std(times));
  log(" median", median(times));

  if (average > maxColdstart) exit(-1);
};
main();
