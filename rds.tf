locals {
  timestamp           = timestamp()
  timestamp_sanitized = replace("${local.timestamp}", "/[- TZ:]/", "")
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = var.mysql_engine_version
  instance_class         = var.mysql_instance_class
  db_name                = var.mysql_name
  username               = var.mysql_username
  password               = random_password.mysql_password.result
  parameter_group_name   = aws_db_parameter_group.default.name
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  skip_final_snapshot    = true
  # final_snapshot_identifier = "${var.mysql_name}-${local.timestamp_sanitized}"

  timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "aws_db_parameter_group" "default" {
  name   = "${local.name_prefix}-pg"
  family = "mysql5.7"
}

resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_subnet_group" "default" {
  name       = "${local.name_prefix}-main"
  subnet_ids = [module.vpc.database_subnets[0], module.vpc.database_subnets[1]]

  tags = merge(var.additional_tags,
    {
      "Name" = "${local.name_prefix}-mysql-subnet-group"
  })
}

resource "aws_security_group" "mysql_sg" {
  name        = "${local.name_prefix}-mysql_sg"
  description = "mysql_sg"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
    security_groups = [aws_security_group.ghost_asg_sg.id]
  }

  egress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "TCP"
    security_groups = [aws_security_group.ghost_asg_sg.id]
  }

  tags = merge(var.additional_tags,
    {
      "Name" = "${local.name_prefix}-mysql-subnet-group"
  })
}