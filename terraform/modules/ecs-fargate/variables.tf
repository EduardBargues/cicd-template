variable "name" {
  type        = string
  description = "The name of the application"
}
variable "app_image" {
  type        = string
  description = "Container image to be used for application in task definition file"
}
variable "app_port" {
  type = number
}
# variable "environment" {
#   type        = string
#   description = "The application environment"
# }

variable "fargate_cpu" {
  type        = number
  description = "Fargate cpu allocation"
}
variable "vpc_id" {
  type = string
}
variable "cluster_id" {
  type = string
}
variable "app_count" {
  type = number
}
variable "fargate_memory" {
  type        = number
  description = "Fargate memory allocation"
}
variable "aws_security_group_ecs_tasks_id" {
  type        = string
  description = "The ID of the security group for the ECS tasks"
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "lb_security_group_id" {
  type = string
}
variable "log_group_name" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "tags" {
  type = map(any)
}
