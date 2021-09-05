resource "aws_lambda_function" "lambda_python" {
  function_name     = "${local.prefix_python}-lambda"
  s3_bucket         = var.lambda_s3_bucket
  s3_key            = local.lambda_s3_key_python
  s3_object_version = data.aws_s3_bucket_object.lambda_python.version_id
  handler           = "main.handler"
  runtime           = "python3.8"
  timeout           = 30
  role              = aws_iam_role.lambda_python_role.arn
  tags              = local.tags
}

resource "aws_iam_role" "lambda_python_role" {
  name = "${local.prefix_python}-iam-role"

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

resource "aws_iam_role_policy_attachment" "lambda_python_cloudwatch_policy" {
  role       = aws_iam_role.lambda_python_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "apigw_python" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_python.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
