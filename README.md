# repo_template## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.40.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.40.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ghost_asg](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/autoscaling_group) | resource |
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/db_subnet_group) | resource |
| [aws_iam_instance_profile.ec2_profile](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_role](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.ghost_lc](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/launch_configuration) | resource |
| [aws_lb.ghost_alb](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/lb) | resource |
| [aws_lb_listener.ghost_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.ghost_lb_listener_https](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ghost_lb_tg](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/lb_target_group) | resource |
| [aws_route53_record.blog](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/route53_record) | resource |
| [aws_security_group.ghost_asg_sg](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/security_group) | resource |
| [aws_security_group.ghost_lb_sg](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/security_group) | resource |
| [aws_security_group.mysql_sg](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/resources/security_group) | resource |
| [random_password.mysql_password](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [aws_acm_certificate.amazon_issued](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/acm_certificate) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/caller_identity) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/4.40.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional resource tags | `map(string)` | `{}` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | n/a | `string` | `1` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | n/a | `string` | `1` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_azs"></a> [azs](#input\_azs) | Availability Zones | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | Private subnets where the RDS instance will be deployed | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24"<br>]</pre> | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | ASG Variables | `string` | `"t2.micro"` | no |
| <a name="input_mysql_engine_version"></a> [mysql\_engine\_version](#input\_mysql\_engine\_version) | Versions available: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html | `string` | `"5.7"` | no |
| <a name="input_mysql_instance_class"></a> [mysql\_instance\_class](#input\_mysql\_instance\_class) | n/a | `string` | `"db.t2.micro"` | no |
| <a name="input_mysql_name"></a> [mysql\_name](#input\_mysql\_name) | n/a | `string` | `"ghostdb"` | no |
| <a name="input_mysql_username"></a> [mysql\_username](#input\_mysql\_username) | n/a | `string` | `"ghostdbuser"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | TF Cloud Organization | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project Name | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnets where the ghost instances will be deployed | `list(string)` | <pre>[<br>  "10.0.101.0/24",<br>  "10.0.102.0/24"<br>]</pre> | no |
| <a name="input_route53_hosted_zone_name"></a> [route53\_hosted\_zone\_name](#input\_route53\_hosted\_zone\_name) | Name of hosted zone for blog | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR range | `string` | `"10.0.0.0/16"` | no |
| <a name="input_website_admin_url"></a> [website\_admin\_url](#input\_website\_admin\_url) | Your ghost website admin URL, has to match the origin (custom domain OR load balancer DNS Name). Can be a subdomain of website\_url | `string` | `""` | no |
| <a name="input_website_url"></a> [website\_url](#input\_website\_url) | Your ghost website URL, has to match the origin (custom domain OR load balancer DNS Name) | `string` | `""` | no |

## Outputs

No outputs.
