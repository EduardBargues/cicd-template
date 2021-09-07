resource "aws_lb" "nlb" {
  name               = "${var.name}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids
  # security_groups            = [var.lb_security_group_id]
  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "nlb_tg" {
  depends_on = [
    aws_lb.nlb
  ]
  name        = "${var.name}-nlb-tg"
  port        = var.app_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  # health_check {
  #   enabled             = true
  #   interval            = 30
  #   path                = "/health-check"
  #   port                = "traffic-port"
  #   healthy_threshold   = 3
  #   unhealthy_threshold = 3
  #   # timeout             = 10
  #   protocol = "HTTP"
  #   matcher  = "200-399"
  # }
  # slow_start = 30
  tags = var.tags
}

# Redirect all traffic from the NLB to the target group
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.id
  port              = var.app_port
  protocol          = "TCP"
  tags              = var.tags
  default_action {
    target_group_arn = aws_lb_target_group.nlb_tg.id
    type             = "forward"
  }
}
