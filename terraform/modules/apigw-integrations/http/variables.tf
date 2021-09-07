# https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2
variable "endpoint_relative_url" {
  type = string
}
variable "rest_api_name" {
  type = string
}
variable "http_method" {
  type = string
}
variable "integration_endpoint_url" {
  type = string
}
