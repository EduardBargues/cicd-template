output "base_url" {
  value = "${aws_api_gateway_deployment.api.invoke_url}${var.environment}"
}
output "diagnostics_endpoint" {
  value = "diagnostics"
}
output "dummy_endpoint" {
  value = "dummy"
}
output "secondary_lambda_name" {
  value = aws_lambda_function.lambda_secondary.function_name
}
