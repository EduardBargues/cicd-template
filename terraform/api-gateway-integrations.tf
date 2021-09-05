module "get_dotnet_function" {
  source = "./modules/apigw-integrations/lambda"

  rest_api_name         = aws_api_gateway_rest_api.api.name
  endpoint_relative_url = local.endpoints.dotnet_function
  http_method           = "GET"
  lambda_invoke_arn     = aws_lambda_function.lambda_dotnet_function.invoke_arn
  lambda_function_name  = aws_lambda_function.lambda_dotnet_function.function_name

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}
module "get_dotnet_webapi" {
  source = "./modules/apigw-integrations/lambda"

  rest_api_name         = aws_api_gateway_rest_api.api.name
  endpoint_relative_url = local.endpoints.dotnet_webapi
  http_method           = "GET"
  lambda_invoke_arn     = aws_lambda_function.lambda_dotnet_webapi.invoke_arn
  lambda_function_name  = aws_lambda_function.lambda_dotnet_webapi.function_name

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}
module "get_nodejs_function" {
  source = "./modules/apigw-integrations/lambda"

  rest_api_name         = aws_api_gateway_rest_api.api.name
  endpoint_relative_url = local.endpoints.nodejs_function
  http_method           = "GET"
  lambda_invoke_arn     = aws_lambda_function.lambda_nodejs.invoke_arn
  lambda_function_name  = aws_lambda_function.lambda_nodejs.function_name

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}
module "get_python_function" {
  source = "./modules/apigw-integrations/lambda"

  rest_api_name         = aws_api_gateway_rest_api.api.name
  endpoint_relative_url = local.endpoints.python_function
  http_method           = "GET"
  lambda_invoke_arn     = aws_lambda_function.lambda_python.invoke_arn
  lambda_function_name  = aws_lambda_function.lambda_python.function_name

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}
# module "get_nodejs_server" {
#   source = "./modules/apigw-integrations/vpc-link"

#   name                  = local.prefixes.nodejs_server
#   rest_api_name         = aws_api_gateway_rest_api.api.name
#   endpoint_relative_url = local.endpoints.nodejs_server
#   http_method           = "GET"
#   nlb_dns_name          = module.ecs_service.nlb_dns_name
#   nlb_arn               = module.ecs_service.nlb_arn
#   app_port              = var.fargate_app_port
#   tags                  = local.tags
#   depends_on = [
#     aws_api_gateway_rest_api.api
#   ]
# }
