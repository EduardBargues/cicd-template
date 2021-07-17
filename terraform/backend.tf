terraform {
  backend "s3" {
    bucket  = "tfm-state-086282490297"
    region  = "eu-west-1"
    key     = "replaceMe.tfstate"
    encrypt = "true"
  }
}

