resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.prefix}-lg"
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "${var.prefix}-ls"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}
