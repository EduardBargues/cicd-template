variable "name" {
  type = string
}
variable "rest_api_name" {
  type = string
}
variable "endpoint_relative_url" {
  type = string
}
variable "http_method" {
  type = string
}
variable "nlb_dns_name" {
  type = string
}
variable "nlb_arn" {
  type = string
}
variable "app_port" {
  type = number
}
variable "tags" {
  type = map(any)
}
