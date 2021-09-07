output "base_url" {
  value     = "${aws_api_gateway_deployment.api.invoke_url}${var.environment}"
  sensitive = true
}

output "endpoints" {
  value = local.endpoints
}

output "alb_url" {
  value = module.ecs.alb_hostname
}
