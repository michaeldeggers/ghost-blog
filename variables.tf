variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "organization" {
  description = "TF Cloud Organization"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Public subnets where the ghost instances will be deployed"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets" {
  description = "Private subnets where the RDS instance will be deployed"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# RDS Vars
variable "mysql_engine_version" {
  description = "Versions available: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html"
  type        = string
  default     = "5.7"
}

variable "mysql_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "mysql_name" {
  type    = string
  default = "ghostdb"
}

variable "mysql_username" {
  type      = string
  sensitive = true
  default   = "ghostdbuser"
}

# ASG Variables
variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "asg_max_size" {
  type    = string
  default = 1
}

variable "asg_min_size" {
  type    = string
  default = 1
}