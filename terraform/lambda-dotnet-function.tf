data "aws_s3_bucket_object" "lambda_dotnet_function" {
  bucket = var.lambda_s3_bucket
  key    = local.lambdas.s3_key_dotnet_function
}
resource "aws_lambda_function" "lambda_dotnet_function" {
  function_name     = "${local.prefixes.dotnet_function}-lambda"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = data.aws_s3_bucket_object.lambda_dotnet_function.key
  s3_object_version = data.aws_s3_bucket_object.lambda_dotnet_function.version_id
  handler           = "Function::Function.Function::FunctionHandler"
  runtime           = "dotnetcore3.1"
  memory_size       = 256
  timeout           = 30
  role              = aws_iam_role.lambda_dotnet_function.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_dotnet_function" {
  name = "${local.prefixes.dotnet_function}-iam-role"

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

resource "aws_iam_role_policy_attachment" "lambda_dotnet_function" {
  role       = aws_iam_role.lambda_dotnet_function.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_dotnet_function" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_dotnet_function.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}
