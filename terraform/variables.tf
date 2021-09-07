variable "service_name" {
  type        = string
  description = "name of the service."
}
variable "service_version" {
  type        = string
  description = "version of the service. Can be a semver like 1.2.3.4, or 1.2.3. Can also be a feature branch name (no / allowed!!)."
}
variable "service_group" {
  type        = string
  description = "group of the service. Will be used to group the resources under a single group. Useful to have several isolated services running in a single aws account."
}
variable "environment" {
  type        = string
  description = "environment name: dev, int, tst, acc, prd, ... "
}
variable "aws_region" {
  type        = string
  description = "aws region"
  sensitive   = true
}
variable "aws_account_id" {
  type        = string
  description = "aws account id"
  sensitive   = true
}
variable "ecr_name" {
  type        = string
  description = "elastic container repository name"
}
variable "docker_image_tag" {
  type        = string
  description = "docker image tag"
}
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "number_of_private_subnets" {
  type    = number
  default = 2
}
variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.4.0/24"]
}
variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "fargate_app_count" {
  type    = number
  default = 2
}
variable "fargate_app_memory" {
  type    = number
  default = 512
}
variable "fargate_app_cpu" {
  type    = number
  default = 256
}
variable "fargate_app_port" {
  type    = number
  default = 80
}
variable "lambda_s3_bucket" {
  type        = string
  description = "name of the s3 bucket that holds the lambda artifacts"
}
