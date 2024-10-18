module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name             = "${local.name_prefix}-vpc"
  cidr             = var.vpc_cidr
  azs              = var.azs
  database_subnets = var.database_subnets
  public_subnets   = var.public_subnets

  tags = var.additional_tags
}
