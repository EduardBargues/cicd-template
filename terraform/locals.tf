locals {
  prefix = "${var.environment}-${var.service_name}-${var.service_group}"
  endpoints = {
    _dotnet_webapi = {
      url         = "dotnet-webapi"
      http_method = "GET"
      config = {
        function_name = "dotnet-webapi"
        s3_key        = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-dotnet-webapi.zip"
        handler       = "WebApi::WebApi.LambdaEntryPoint::FunctionHandlerAsync"
        runtime       = "dotnetcore3.1"
        memory_size   = 256
        timeout       = 30
      }
    }
    _dotnet_function = {
      url         = "dotnet-function"
      http_method = "GET"
      config = {
        function_name = "dotnet-function"
        s3_key        = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-dotnet-function.zip"
        handler       = "Function::Function.Function::FunctionHandler"
        runtime       = "dotnetcore3.1"
        memory_size   = 256
        timeout       = 30
      }
    }
    _nodejs_function = {
      url         = "nodejs-function"
      http_method = "GET"
      config = {
        function_name = "nodejs"
        s3_key        = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-nodejs.zip"
        handler       = "main.handler"
        runtime       = "nodejs14.x"
        memory_size   = 256
        timeout       = 30
      }
    }
    _python_function = {
      url         = "python-function"
      http_method = "GET"
      config = {
        function_name = "python"
        s3_key        = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-python.zip"
        handler       = "main.handler"
        runtime       = "python3.8"
        memory_size   = 256
        timeout       = 30
      }
    }
    # _nodejs_server = {
    #   url         = "nodejs-server"
    #   http_method = "GET"
    #   type        = local.types.ECS
    #   config = {
    #     name                     = "server"
    #     integration_endpoint_url = "nodejs-server"
    #     docker_image_url         = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_name}:${var.docker_image_tag}"
    #     port                     = 8080
    #     count                    = 1
    #     health_check_path        = "health-check"
    #     cpu                      = 256
    #     memory                   = 512
    #     az_count                 = 2
    #   }
    # }
    #variable "ecr_name" {
    #  type        = string
    #  description = "elastic container repository name"
    #}
    #variable "docker_image_tag" {
    #  type        = string
    #  description = "docker image tag"
    #}
  }

  logs_retention_in_days = 1
  apigw_name             = "${local.prefix}-apigw"
  default_tags = {
    "service-name"    = var.service_name
    "service-version" = var.service_version
    "service-group"   = var.service_group
    "environment"     = var.environment
  }
}
