output "base_url" {
  value     = "${aws_api_gateway_deployment.api.invoke_url}${var.environment}"
  sensitive = true
}
output "dotnet_endpoint" {
  value = local.dotnet_endpoint
}
output "nodejs_endpoint" {
  value = local.nodejs_endpoint
}
