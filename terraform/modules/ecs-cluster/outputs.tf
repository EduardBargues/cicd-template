output "arn" {
  value = aws_ecs_cluster.main.arn
}
output "id" {
  value = aws_ecs_cluster.main.id
}
output "log_group_name" {
  value = aws_cloudwatch_log_group.cluster.name
}
