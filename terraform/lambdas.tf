module "lambdas" {
  source = "./modules/lambda"

  for_each = local.endpoints

  s3_bucket              = var.lambda_s3_bucket
  s3_key                 = each.value.config.s3_key
  function_name          = "${local.prefix}-${each.value.config.function_name}"
  handler                = each.value.config.handler
  runtime                = each.value.config.runtime
  memory_size            = each.value.config.memory_size
  timeout                = each.value.config.timeout
  iam_role_name          = "${local.prefix}-${each.value.config.function_name}"
  logs_retention_in_days = local.logs_retention_in_days
}
