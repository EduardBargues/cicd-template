output "invoke_arn" {
  value = aws_lambda_function.main.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.main.function_name
}
