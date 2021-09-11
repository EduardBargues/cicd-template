import http from "k6/http";
import { check } from "k6";
import { Trend, Rate } from "k6/metrics";

const endpoints = {
  _dotnet_webapi: "http://host.docker.internal:5000/dotnet-webapi",
  _nodejs_server: "http://host.docker.internal:8080/health-check",
};

let operationsTrends = {};
let operationsErrorRate = {};
let thresholds = {};
for (const endpointName in endpoints) {
  operationsErrorRate[endpointName] = new Rate(endpointName);
  operationsTrends[endpointName] = new Trend(endpointName);
  thresholds[endpointName] = ["p(95)<250", "max < 2500"];
}

export let options = {
  thresholds: thresholds,
  stages: [
    { duration: "5s", target: 10 },
    { duration: "10s", target: 10 },
    { duration: "5s", target: 0 },
  ],
};

export default function () {
  let requests = {};
  for (const endpointName in endpoints) {
    const url = endpoints[endpointName];
    const request = {
      method: "GET",
      url: url,
    };
    requests[endpointName] = request;
  }

  let responses = http.batch(requests);

  for (const endpointName in endpoints) {
    let listResp = responses[endpointName];
    let listErrorRate = operationsErrorRate[endpointName];
    check(listResp, {
      "status is 200": (r) => r.status === 200,
    }) || listErrorRate.add(1);

    let listTrend = operationsTrends[endpointName];
    listTrend.add(listResp.timings.duration);
  }
}
