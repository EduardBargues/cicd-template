resource "aws_api_gateway_rest_api" "api" {
  name = "${local.prefix}-api-gateway"
  tags = local.tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.get_dotnet,
    aws_api_gateway_integration.get_dotnet_function,
    aws_api_gateway_integration.get_nodejs,
    aws_api_gateway_integration.get_python,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.get_dotnet.id,
      aws_api_gateway_resource.get_dotnet_function.id,
      aws_api_gateway_resource.get_nodejs.id,
      aws_api_gateway_resource.get_python.id,
      aws_api_gateway_method.get_dotnet.id,
      aws_api_gateway_method.get_dotnet_function.id,
      aws_api_gateway_method.get_nodejs.id,
      aws_api_gateway_method.get_python.id,
      aws_api_gateway_integration.get_dotnet.id,
      aws_api_gateway_integration.get_dotnet_function.id,
      aws_api_gateway_integration.get_nodejs.id,
      aws_api_gateway_integration.get_python.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api" {
  stage_name    = var.environment
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
}

resource "aws_api_gateway_method_settings" "apigw" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]

    }
  }
}
resource "aws_iam_role" "main" {
  name = "${aws_api_gateway_rest_api.api.name}-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "cw_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.main.arn]
  }
}
resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.main.id

  policy = data.aws_iam_policy_document.cw_policy.json

}
