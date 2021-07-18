resource "aws_lambda_function" "lambda" {
  function_name = "${local.prefix}-lambda"
  filename      = "../${var.service_name}-${var.service_version}.zip"
  handler       = "WebApi::WebApi.LambdaEntryPoint::FunctionHandlerAsync"
  runtime       = "dotnetcore3.1"
  memory_size   = 256
  timeout       = 30
  role          = aws_iam_role.lambda_role.arn
  tags          = local.tags
}

resource "aws_iam_role" "lambda_role" {
  name = "${local.prefix}-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
