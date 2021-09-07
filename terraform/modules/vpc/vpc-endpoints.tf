resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id
  security_group_ids  = [aws_security_group.vpc_api_endpoint.id]
  tags                = var.tags
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id
  security_group_ids  = [aws_security_group.vpc_api_endpoint.id]
  tags                = var.tags
}
resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = aws_vpc.custom_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_subnet.*.id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc_api_endpoint.id]
  tags                = var.tags
}
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.custom_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_vpc.custom_vpc.main_route_table_id] #"rtb-02aba28ed613373d8"] #var.main_pvt_route_table_id]
  tags              = var.tags
}
