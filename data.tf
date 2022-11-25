data "aws_caller_identity" "current" {}

data "aws_route53_zone" "zone" {
  name = var.route53_hosted_zone_name
}

# Find a certificate issued by (not imported into) ACM
data "aws_acm_certificate" "default" {
  domain      = var.route53_hosted_zone_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}