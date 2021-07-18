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
variable "destination_account_id" {
  type        = string
  description = "aws account id where the deployment (or destroy) will take place."
  sensitive   = true
}
variable "aws_region" {
  type        = string
  description = "aws region"
  sensitive   = true
}
variable "deployment_role_name" {
  type        = string
  description = "name of the role to be assumed by terraform so is able to properly apply/deploy"
  sensitive   = true
}
