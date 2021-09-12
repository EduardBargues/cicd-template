output "endpoints" {
  value = zipmap(keys(local.endpoints), [for endpointName in keys(local.endpoints) : "${aws_api_gateway_deployment.api.invoke_url}${var.environment}/${local.endpoints[endpointName]}"])
}
