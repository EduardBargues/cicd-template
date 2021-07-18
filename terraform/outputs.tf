output "base_url" {
  value = "${aws_api_gateway_deployment.api.invoke_url}${var.environment}"
}
output "diagnostics_endpoint" {
  value = "diagnostics"
}
