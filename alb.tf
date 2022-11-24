resource "aws_lb" "ghost_alb" {
  name               = "${local.name_prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ghost_lb_sg.id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  tags = merge(var.additional_tags,
    {
      "Name" = "${local.name_prefix}-alb"
  })
}

resource "aws_lb_listener" "ghost_lb_listener" {
  load_balancer_arn = aws_lb.ghost_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ghost_lb_tg.arn
  }
}


resource "aws_lb_target_group" "ghost_lb_tg" {
  name                 = "${local.name_prefix}-tg"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 180
  vpc_id               = module.vpc.vpc_id

  health_check {
    healthy_threshold = 3
    interval          = 10
  }

  tags = merge(var.additional_tags,
    {
      "Name" = "${local.name_prefix}-alb"
  })
}

resource "aws_security_group" "ghost_lb_sg" {
  name   = "${local.name_prefix}-sg-alb"
  vpc_id = module.vpc.vpc_id

  # Accept http traffic from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.additional_tags,
    {
      "Name" = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_route53_record" "blog" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "blog.${var.route53_hosted_zone_name}"
  type    = "A"
  alias {
    name                   = aws_lb.ghost_alb.dns_name
    zone_id                = aws_lb.ghost_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "admin" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "admin.${var.route53_hosted_zone_name}"
  type    = "A"
  alias {
    name                   = aws_lb.ghost_alb.dns_name
    zone_id                = aws_lb.ghost_alb.zone_id
    evaluate_target_health = true
  }
}
