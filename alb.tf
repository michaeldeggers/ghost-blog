resource "aws_lb" "ghost_alb" {
  name                       = "${local.name_prefix}-alb"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ghost_lb_sg.id]
  subnets                    = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  drop_invalid_header_fields = true
  enable_deletion_protection = true
  
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "log/"
    enabled = true
  }

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
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ghost_lb_listener_https" {
  load_balancer_arn = aws_lb.ghost_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ghost_lb_tg.arn
  }
}

resource "aws_lb_target_group" "ghost_lb_tg" {
  name_prefix          = substr("${var.project_name}", 0, 6)
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 180
  vpc_id               = module.vpc.vpc_id

  health_check {
    healthy_threshold = 3
    interval          = 10
    path              = "/"
    matcher           = "200" # has to be HTTP 200 or fails
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
    description = "Accept https traffic from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow communication out to internet"
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

resource "aws_s3_bucket" "lb_logs" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "Ghost-Blog Access Logs"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "lb_logs" {
  bucket = aws_s3_bucket.lb_logs.bucket

  rule {
    id = "log"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}