data "aws_s3_bucket_object" "lambda_python" {
  bucket = var.lambda_s3_bucket
  key    = local.lambdas.s3_key_python
}
resource "aws_lambda_function" "lambda_python" {
  function_name     = "${local.prefix}-python-function"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = data.aws_s3_bucket_object.lambda_python.key
  s3_object_version = data.aws_s3_bucket_object.lambda_python.version_id
  handler           = "main.handler"
  runtime           = "python3.8"
  timeout           = 30
  role              = aws_iam_role.lambda_python.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_python" {
  name = "${local.prefix}-python-function"

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

resource "aws_iam_role_policy_attachment" "lambda_python" {
  role       = aws_iam_role.lambda_python.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_python" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_python.function_name}"
  retention_in_days = local.logs_retention_in_days
  tags              = local.tags
}
