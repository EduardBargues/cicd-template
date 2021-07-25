resource "aws_cloudwatch_log_group" "main" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${var.environment}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}

resource "aws_cloudwatch_log_group" "dotnet" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_dotnet.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}

resource "aws_cloudwatch_log_group" "nodejs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_nodejs.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}

resource "aws_cloudwatch_log_group" "python" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_python.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}
