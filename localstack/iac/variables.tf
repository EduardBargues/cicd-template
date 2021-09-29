# variable to define aws region
variable "aws_region" {
  type    = string
  default = "us-east-1"

}

# variable to define host where localstack port is exposed
variable "host" {
  type    = string
  default = "http://localhost:4566"

}
