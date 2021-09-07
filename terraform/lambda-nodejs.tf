data "aws_s3_bucket_object" "lambda_nodejs" {
  bucket = var.lambda_s3_bucket
  key    = local.lambdas.s3_key_nodejs
}
resource "aws_lambda_function" "lambda_nodejs" {
  function_name     = "${local.prefix}-nodejs"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = data.aws_s3_bucket_object.lambda_nodejs.key
  s3_object_version = data.aws_s3_bucket_object.lambda_nodejs.version_id
  handler           = "main.handler"
  runtime           = "nodejs14.x"
  timeout           = 30
  role              = aws_iam_role.lambda_nodejs.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_nodejs" {
  name = "${local.prefix}-nodejs-function"

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

resource "aws_iam_role_policy_attachment" "lambda_nodejs" {
  role       = aws_iam_role.lambda_nodejs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_nodejs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_nodejs.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}
