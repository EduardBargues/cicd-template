resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "private_subnet" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags              = var.tags
}

resource "aws_security_group" "lb" {
  name        = var.security_group_lb_name
  description = var.security_group_lb_description
  vpc_id      = aws_vpc.custom_vpc.id
  tags        = var.tags


  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = var.security_group_ecs_tasks_name
  description = var.security_group_ecs_tasks_description
  vpc_id      = aws_vpc.custom_vpc.id
  tags        = var.tags
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr_block]
  }

  # egress {
  #   from_port = 443
  #   to_port   = 443
  #   protocol  = "tcp"
  #   prefix_list_ids = [
  #     aws_vpc_endpoint.s3.prefix_list_id
  #   ]
  # }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_api_endpoint" {
  # TODO: changes those 2 tf variables!
  name_prefix = var.security_group_ecs_tasks_name
  # name        = var.security_group_ecs_tasks_name
  description = var.security_group_ecs_tasks_description
  vpc_id      = aws_vpc.custom_vpc.id
  tags        = var.tags

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    # cidr_blocks = [var.vpc_cidr_block]
    security_groups = [aws_security_group.ecs_tasks.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
