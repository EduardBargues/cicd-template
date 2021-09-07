variable "name" {
  type        = string
  description = "The name of the cluster"
}

variable "tags" {
  type        = map(any)
  description = "tags"
}
variable "logs_retention_in_days" {
  type = number
}
