output "integration_id" {
  value = aws_api_gateway_integration.integration.id
}
output "resource_id" {
  value = aws_api_gateway_resource.resource.id
}
output "method_id" {
  value = aws_api_gateway_method.method.id
}
