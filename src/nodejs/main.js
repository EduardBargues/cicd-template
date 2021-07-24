"use strict";

exports.handler = async (event, context) => {
  console.log("NODEJS LAMBDA EXECUTION");
  return {
    statusCode: 200,
    headers: {},
    body: "nodejs-lambda",
    isBase64Encoded: false,
  };
};
