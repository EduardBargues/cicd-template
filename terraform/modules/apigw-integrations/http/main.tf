data "aws_api_gateway_rest_api" "api" {
  name = var.rest_api_name
}
resource "aws_api_gateway_resource" "resource" {
  path_part   = var.endpoint_relative_url
  parent_id   = data.aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = data.aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = data.aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = data.aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = aws_api_gateway_method.method.http_method
  uri                     = var.integration_endpoint_url
}
