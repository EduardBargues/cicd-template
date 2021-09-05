resource "aws_ecs_cluster" "main" {
  name = var.name
  tags = var.tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster.name
      }
    }
  }
}
resource "aws_cloudwatch_log_group" "cluster" {
  name              = "${var.name}-log-group"
  tags              = var.tags
  retention_in_days = var.logs_retention_in_days
}
