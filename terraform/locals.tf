locals {
  prefix              = "${var.service_name}-${var.service_group}"
  deployment_role_arn = "arn:aws:iam::${var.destination_account_id}:role/${var.deployment_role_name}"
  tags = {
    "service-name"    = var.service_name
    "service-version" = var.service_version
    "service-group"   = var.service_group
    "environment"     = var.environment
  }
}
