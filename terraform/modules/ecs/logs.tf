resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.app_name}-lg"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "${var.app_name}-ls"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}
