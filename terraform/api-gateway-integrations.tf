module "lambda_endpoints" {
  source = "./modules/apigw-integrations/lambda"

  for_each = local.endpoints

  rest_api_name         = aws_api_gateway_rest_api.api.name
  endpoint_relative_url = local.endpoints[each.key].url
  http_method           = local.endpoints[each.key].http_method
  lambda_invoke_arn     = module.lambdas[each.key].invoke_arn
  lambda_function_name  = module.lambdas[each.key].function_name
  depends_on = [
    aws_api_gateway_rest_api.api,
    module.lambdas
  ]
}

# # module "ecs_endpoints" {
# #   source = "./modules/apigw-integrations/http"

# #   for_each = local.ecs_endpoints

# #   rest_api_name            = aws_api_gateway_rest_api.api.name
# #   endpoint_relative_url    = local.endpoints[each.key].url
# #   http_method              = local.endpoints[each.key].http_method
# #   integration_endpoint_url = "http://${module.ecs[each.key].alb_hostname}:${local.endpoints[each.key].config.port}/${local.endpoints[each.key].config.integration_endpoint_url}"

# #   depends_on = [
# #     aws_api_gateway_rest_api.api,
# #     module.ecs
# #   ]
# # }
