module "ecs" {
  source = "./modules/ecs"

  aws_region            = data.aws_region.current.name
  prefix                = local.prefix
  az_count              = 2
  app_image             = local.docker_image_url
  app_port              = var.app_port
  app_count             = var.app_count
  health_check_path     = "/health-check"
  fargate_cpu           = var.app_cpu
  fargate_memory        = var.app_memory
  log_retention_in_days = local.logs_retention_in_days
  tags                  = local.tags
}
