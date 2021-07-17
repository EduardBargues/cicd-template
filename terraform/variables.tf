variable "service_version" {
  type        = string
  description = "version of the service. Can be a semver like 1.2.3.4, or 1.2.3. Can also be a feature branch name (no / allowed!!) or ticket number (LANZ-947) for testing purposes."
}
variable "service_group" {
  type        = string
  description = "group of the service. Will be used to group the resources under a single group. Useful to have several isolated services running in a single aws account."
}
variable "environment" {
  type        = string
  description = "environment name: dev, int, tst, acc, prd, ... "
}
variable "destination_account_id" {
  type        = string
  description = "aws account id where the deployment (or destroy) will take place."
}
variable "client_name" {
  type        = string
  description = "name of the client that will receive the deployment (or destroy). Can be a customer (like tkp, rbc, ...) or a team (like savings, investments, payments, ...)"
}
variable "service_name" {
  type        = string
  description = "name of the service."
}

# DEFAULT VARS
variable "aws_region" {
  type        = string
  description = "aws region. you shouldn't need to change that ..."
  default     = "eu-west-1"
}
variable "sufix" {
  type        = string
  description = "sufix that will be added to your resources names. Empty by default"
  default     = ""
}

# DO NOT CHANGE!
variable "tfm_x_acc_role_name" {
  type        = string
  default     = "xops-tfm-adm-x-acc-role"
  description = "do not modify!"
}
variable "main_project" {
  default     = "Ohpen.ServiceName.WebApi"
  type        = string
  description = "name of the dotnet main project"
}
variable "secondary_project" {
  default     = "Ohpen.ServiceNameSecondary.WebApi"
  type        = string
  description = "name of the dotnet secondary project"
}
locals {
  account_name        = "${var.client_name}-${var.environment}"
  prefix              = "${local.account_name}-${var.service_name}-${var.service_group}"
  tfm_deploy_role_arn = "arn:aws:iam::${var.destination_account_id}:role/${var.tfm_x_acc_role_name}-${var.environment}"
}
