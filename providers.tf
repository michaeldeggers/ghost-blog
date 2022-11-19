# Using a single workspace:
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
  required_version = ">= 1.1.0"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "eggs-projects"

    workspaces {
      prefix = "eggs-projects-"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/eggs-projects-${var.project_name}-role"
    session_name = "Session_GitHub_Actions"
  }
}
