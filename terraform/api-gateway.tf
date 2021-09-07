resource "aws_api_gateway_rest_api" "api" {
  name = local.apigw_name
  tags = local.tags
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    module.get_dotnet_webapi,
    module.get_dotnet_function,
    module.get_nodejs_function,
    # module.get_nodejs_server,
    module.get_python_function,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      module.get_dotnet_webapi.resource_id,
      module.get_dotnet_function.resource_id,
      module.get_nodejs_function.resource_id,
      # module.get_nodejs_server.resource_id,
      module.get_python_function.resource_id,
      module.get_dotnet_webapi.method_id,
      module.get_dotnet_function.method_id,
      module.get_nodejs_function.method_id,
      # module.get_nodejs_server.method_id,
      module.get_python_function.method_id,
      module.get_dotnet_webapi.integration_id,
      module.get_dotnet_function.integration_id,
      module.get_nodejs_function.integration_id,
      # module.get_nodejs_server.integration_id,
      module.get_python_function.integration_id,
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

resource "aws_cloudwatch_log_group" "main" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${var.environment}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}
