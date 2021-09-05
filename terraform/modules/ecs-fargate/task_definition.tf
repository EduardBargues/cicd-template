resource "aws_ecs_task_definition" "main" {
  family                   = var.name
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.main_ecs_tasks.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  tags                     = var.tags
  container_definitions = jsonencode([
    {
      name : var.name,
      image : var.app_image, #repository-url/image:tag
      cpu : var.fargate_cpu,
      memory : var.fargate_memory,
      networkMode : "awsvpc",
      portMappings : [
        {
          containerPort : var.app_port
          # protocol : "tcp",
          hostPort : var.app_port
        }
      ]
      log_config_aws_logs : {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
