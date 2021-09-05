terraform {
  backend "s3" {
    bucket = "main-413901771600"
    region = "eu-west-1"
    key    = "infra-states/dev/service/feature-ecs/service-dev-feature-ecs.tfstate"
  }
}
