# module "ecs" {
#   source = "./modules/ecs"

#   for_each = local.ecs_endpoints

#   aws_region        = var.aws_region
#   app_name          = "${local.prefix}-${each.value.config.name}"
#   az_count          = each.value.config.az_count
#   app_image         = each.value.config.docker_image_url
#   app_port          = each.value.config.port
#   app_count         = each.value.config.count
#   health_check_path = "/${each.value.config.health_check_path}"
#   fargate_cpu       = each.value.config.cpu
#   fargate_memory    = each.value.config.memory

#   log_retention_in_days = local.logs_retention_in_days
# }
