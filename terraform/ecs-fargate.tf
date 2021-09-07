# module "vpc" {
#   source = "./modules/vpc"

#   number_of_private_subnets     = 2
#   security_group_lb_name        = "${local.prefixes.main}-alb-sg"
#   security_group_ecs_tasks_name = "${local.prefixes.main}-ecs-tasks-sg"
#   app_port                      = var.fargate_app_port
#   availability_zones            = var.availability_zones
#   aws_region                    = data.aws_region.current.name
#   vpc_cidr_block                = var.vpc_cidr_block
#   private_subnet_cidr_blocks    = var.private_subnet_cidr_blocks
#   tags                          = local.tags
# }
# module "ecs_service" {
#   source = "./modules/ecs-fargate"

#   name                            = local.prefixes.main
#   app_image                       = local.fargate.docker_image_url
#   fargate_cpu                     = var.fargate_app_cpu
#   fargate_memory                  = var.fargate_app_memory
#   app_port                        = var.fargate_app_port
#   vpc_id                          = module.vpc.vpc_id
#   cluster_id                      = module.ecs_cluster.id
#   app_count                       = var.fargate_app_count
#   aws_security_group_ecs_tasks_id = module.vpc.ecs_tasks_security_group_id
#   private_subnet_ids              = module.vpc.private_subnet_ids
#   lb_security_group_id            = module.vpc.lb_security_group_id
#   log_group_name                  = module.ecs_cluster.log_group_name
#   aws_region                      = data.aws_region.current.name
#   tags                            = local.tags
# }
# module "ecs_cluster" {
#   source = "./modules/ecs-cluster"

#   name                   = "${local.prefixes.main}-cluster"
#   logs_retention_in_days = local.logs_retention_in_days
#   tags                   = local.tags
# }
