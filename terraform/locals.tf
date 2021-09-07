locals {
  prefix           = "${var.environment}-${var.service_name}-${var.service_group}"
  docker_image_url = "${var.aws_account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.ecr_name}:${var.docker_image_tag}"
  lambdas = {
    s3_key_dotnet_webapi   = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-dotnet-webapi.zip"
    s3_key_dotnet_function = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-dotnet-function.zip"
    s3_key_nodejs          = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-nodejs.zip"
    s3_key_python          = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-python.zip"
  }
  endpoints = {
    dotnet_webapi   = "dotnet-webapi"
    dotnet_function = "dotnet-function"
    nodejs_function = "nodejs-function"
    nodejs_server   = "nodejs-server"
    python_function = "python-function"
  }
  logs_retention_in_days = 1
  apigw_name             = "${local.prefix}-apigw"
  tags = {
    "service-name"    = var.service_name
    "service-version" = var.service_version
    "service-group"   = var.service_group
    "environment"     = var.environment
  }
}
