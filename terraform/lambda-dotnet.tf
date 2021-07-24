data "aws_s3_bucket_object" "lambda_dotnet" {
  bucket = var.lambda_s3_bucket
  key    = local.lambda_s3_key_dotnet
}

resource "aws_lambda_function" "lambda_dotnet" {
  function_name     = "${local.prefix_dotnet}-lambda"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = local.lambda_s3_key_dotnet
  s3_object_version = data.aws_s3_bucket_object.lambda_dotnet.version_id
  handler           = "WebApi::WebApi.LambdaEntryPoint::FunctionHandlerAsync"
  runtime           = "dotnetcore3.1"
  memory_size       = 256
  timeout           = 30
  role              = aws_iam_role.lambda_dotnet_role.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_dotnet_role" {
  name = "${local.prefix_dotnet}-iam-role"

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

resource "aws_iam_role_policy_attachment" "lambda_dotnet_cloudwatch_policy" {
  role       = aws_iam_role.lambda_dotnet_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "apigw_dotnet" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_dotnet.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
