variable "s3_bucket" {
  type = string
}
variable "s3_key" {
  type = string
}
variable "function_name" {
  type = string
}
variable "handler" {
  type = string
}
variable "runtime" {
  type = string
}
variable "memory_size" {
  type = number
}
variable "timeout" {
  type = number
}
variable "iam_role_name" {
  type = string
}
variable "logs_retention_in_days" {
  type = number
}
