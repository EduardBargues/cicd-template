output "base_url" {
  value     = "${aws_api_gateway_deployment.api.invoke_url}${var.environment}"
  sensitive = true
}
output "dotnet_endpoint" {
  value = local.dotnet_endpoint
}
output "dotnet_function_endpoint" {
  value = local.dotnet_function_endpoint
}
output "nodejs_endpoint" {
  value = local.nodejs_endpoint
}
output "python_endpoint" {
  value = local.python_endpoint
}
