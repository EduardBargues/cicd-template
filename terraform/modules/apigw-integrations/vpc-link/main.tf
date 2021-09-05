data "aws_api_gateway_rest_api" "main" {
  name = var.rest_api_name
}
resource "aws_api_gateway_resource" "main" {
  rest_api_id = data.aws_api_gateway_rest_api.main.id
  parent_id   = data.aws_api_gateway_rest_api.main.root_resource_id
  path_part   = var.endpoint_relative_url
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = data.aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = var.http_method
  authorization = "NONE"

  #   request_parameters = {
  #     "method.request.path.proxy" = true
  #   }
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id = data.aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method

  #   request_parameters = {
  #     "integration.request.path.proxy" = "method.request.path.proxy"
  #   }

  type                    = "HTTP_PROXY" #var.integration_input_type
  uri                     = "http://${var.nlb_dns_name}:${var.app_port}/{proxy}"
  integration_http_method = "ANY" #var.integration_http_method

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.this.id
}

resource "aws_api_gateway_vpc_link" "this" {
  name        = "${var.name}-vpc-link"
  target_arns = [var.nlb_arn]
  tags        = var.tags
}
