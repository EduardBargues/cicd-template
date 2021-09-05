"use strict";

exports.handler = async (event, context) => {
  console.log(`NODEJS LAMBDA EXECUTION
    request-id: ${event.requestContext.requestId}
    aws-request-id: ${context.awsRequestId}`);
  return {
    statusCode: 200,
    headers: {},
    body: "nodejs-lambda",
    isBase64Encoded: false,
  };
};
