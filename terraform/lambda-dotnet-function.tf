
resource "aws_lambda_function" "lambda_dotnet_function" {
  function_name     = "${local.prefix_dotnet_function}-lambda"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = local.lambda_s3_key_dotnet_function
  s3_object_version = data.aws_s3_bucket_object.lambda_dotnet_function.version_id
  handler           = "Function::Function.Function::FunctionHandler"
  runtime           = "dotnetcore3.1"
  memory_size       = 256
  timeout           = 30
  role              = aws_iam_role.lambda_dotnet_function_role.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_dotnet_function_role" {
  name = "${local.prefix_dotnet_function}-iam-role"

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

resource "aws_iam_role_policy_attachment" "lambda_dotnet_function_cloudwatch_policy" {
  role       = aws_iam_role.lambda_dotnet_function_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "apigw_dotnet_function" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_dotnet_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
