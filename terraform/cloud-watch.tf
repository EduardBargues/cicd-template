resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
}
