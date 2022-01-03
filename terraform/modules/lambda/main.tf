data "aws_s3_bucket_object" "main" {
  bucket = var.s3_bucket
  key    = var.s3_key
}
resource "aws_lambda_function" "main" {
  function_name     = var.function_name
  s3_bucket         = var.s3_bucket
  s3_key            = data.aws_s3_bucket_object.main.key
  s3_object_version = data.aws_s3_bucket_object.main.version_id
  handler           = var.handler
  runtime           = var.runtime
  memory_size       = var.memory_size
  timeout           = var.timeout
  role              = aws_iam_role.main.arn
}

resource "aws_iam_role" "main" {
  name = var.iam_role_name

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

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${aws_lambda_function.main.function_name}"
  retention_in_days = var.logs_retention_in_days
}
