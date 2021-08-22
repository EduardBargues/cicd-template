output "base_url" {
  value     = "${aws_api_gateway_deployment.api.invoke_url}${var.environment}"
  sensitive = true
}

output "endpoints" {
  value = {
    dotnet_endpoint : local.dotnet_endpoint
    dotnet_function_endpoint : local.dotnet_function_endpoint
    nodejs_endpoint : local.nodejs_endpoint
    python_endpoint : local.python_endpoint
  }
}
