data "aws_s3_bucket_object" "lambda_dotnet_webapi" {
  bucket = var.lambda_s3_bucket
  key    = local.lambdas.s3_key_dotnet_webapi
}
resource "aws_lambda_function" "lambda_dotnet_webapi" {
  function_name     = "${local.prefixes.dotnet_webapi}-lambda"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = data.aws_s3_bucket_object.lambda_dotnet_webapi.key
  s3_object_version = data.aws_s3_bucket_object.lambda_dotnet_webapi.version_id
  handler           = "WebApi::WebApi.LambdaEntryPoint::FunctionHandlerAsync"
  runtime           = "dotnetcore3.1"
  memory_size       = 256
  timeout           = 30
  role              = aws_iam_role.lambda_dotnet_webapi.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_dotnet_webapi" {
  name = "${local.prefixes.dotnet_webapi}-iam-role"

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

resource "aws_iam_role_policy_attachment" "lambda_dotnet_webapi" {
  role       = aws_iam_role.lambda_dotnet_webapi.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_dotnet_webapi" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_dotnet_webapi.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}
