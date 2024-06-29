locals {
  resource_name = "${var.resource_prefix}-${var.service_name}"
}

module "alb" {
  source = "../../../common/security_group"

  resource_prefix = var.resource_prefix
  usage_name      = "http"
  vpc_id          = var.vpc_id
  ingress_rules = [
    {
      allow_port = 80
      allow_cidrs = ["0.0.0.0/0"]
    },
    {
      allow_port = 443
      allow_cidrs = ["0.0.0.0/0"]
    },
    {
      allow_port = 8080
      allow_cidrs = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_lb" "this" {
  name                       = "${local.resource_name}-alb"
  load_balancer_type         = "application"
  internal                   = var.is_internal
  enable_deletion_protection = false
  subnets = var.subnet_ids

  security_groups = [
    module.alb.security_group_id
  ]
}

resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.1.arn
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.this.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.2.arn
  }
}

resource "aws_lb_target_group" "1" {
  name        = "${local.resource_name}-1-tg"
  vpc_id      = var.vpc_id
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [
    aws_lb.this
  ]
}


resource "aws_lb_target_group" "2" {
  name        = "${local.resource_name}-2-tg"
  vpc_id      = var.vpc_id
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [
    aws_lb.this
  ]
}