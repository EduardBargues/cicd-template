import http from "k6/http";
import { check } from "k6";
import { Trend, Rate } from "k6/metrics";
const api = JSON.parse(open("app.json"));

const endpoints = api.endpoints.value;
let trends = {};
let errorRates = {};
let thresholds = {};
for (const endpointName in endpoints) {
  errorRates[endpointName] = new Rate(`${endpointName}_error_rate`);
  trends[endpointName] = new Trend(`${endpointName}_stats`);
  thresholds[endpointName] = ["p(95)<250", "max < 2500"];
}

export let options = {
  thresholds: thresholds,
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
    let response = responses[endpointName];
    let rate = errorRates[endpointName];
    check(response, {
      "status is 200": (r) => r.status === 200,
    }) || rate.add(1);
    let trend = trends[endpointName];
    trend.add(response.timings.duration);
  }
}
