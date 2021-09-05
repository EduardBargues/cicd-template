resource "aws_api_gateway_resource" "get_dotnet_webapi" {
  path_part   = local.dotnet_endpoint
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "get_dotnet_webapi" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.get_dotnet_webapi.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_dotnet_webapi" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.get_dotnet_webapi.id
  http_method             = aws_api_gateway_method.get_dotnet_webapi.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_dotnet.invoke_arn
}
