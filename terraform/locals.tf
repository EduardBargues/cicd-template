locals {
  prefix               = "${var.environment}-${var.service_name}-${var.service_group}"
  prefix_dotnet        = "${local.prefix}-dotnet"
  prefix_nodejs        = "${local.prefix}-nodejs"
  lambda_s3_key_dotnet = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-dotnet.zip"
  lambda_s3_key_nodejs = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}-nodejs.zip"
  dotnet_endpoint      = "dotnet"
  nodejs_endpoint      = "nodejs"
  tags = {
    "service-name"    = var.service_name
    "service-version" = var.service_version
    "service-group"   = var.service_group
    "environment"     = var.environment
  }
}
