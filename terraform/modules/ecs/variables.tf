#https://github.com/bradford-hamilton/terraform-ecs-fargate
variable "aws_region" {
  description = "The AWS region things are created in"
}
variable "app_name" {
  type        = string
  description = "name of the application. Used for resource naming."
}
variable "az_count" {
  description = "Number of AZs to cover in a given region"
  type        = number
}
variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  type        = string
}
variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  type        = number
}
variable "app_count" {
  description = "Number of docker containers to run"
  type        = number
}
variable "health_check_path" {
  type = string
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = number
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  type        = number
}

variable "log_retention_in_days" {
  type = number
}
