data "aws_caller_identity" "current" {}

data "aws_route53_zone" "zone" {
  name = var.route53_hosted_zone_name
}
