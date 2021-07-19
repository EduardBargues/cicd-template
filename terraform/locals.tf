locals {
  prefix        = "${var.environment}-${var.service_name}-${var.service_group}"
  lambda_s3_key = "artifacts/${var.service_name}/${var.service_version}/${var.service_name}-${var.service_version}.zip"
  tags = {
    "service-name"    = var.service_name
    "service-version" = var.service_version
    "service-group"   = var.service_group
    "environment"     = var.environment
  }
}
