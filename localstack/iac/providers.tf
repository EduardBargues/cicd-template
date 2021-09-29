# AWS provider details for accesing localstack
provider "aws" {
  access_key                  = "mock_access_key"
  region                      = var.aws_region
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_force_path_style         = true

  endpoints {
    s3         = var.host
    lambda     = var.host
    iam        = var.host
    apigateway = var.host
  }
}

# Provider for archive. To manage archive files
provider "archive" {}