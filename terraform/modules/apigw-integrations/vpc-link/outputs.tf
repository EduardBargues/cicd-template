output "integration_id" {
  value = aws_api_gateway_integration.main.id
}
output "resource_id" {
  value = aws_api_gateway_resource.main.id
}
output "method_id" {
  value = aws_api_gateway_method.main.id
}
