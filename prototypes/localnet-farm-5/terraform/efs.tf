# https://github.com/terraform-aws-modules/terraform-aws-efs/blob/master/examples/complete/main.tf
module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  name = "${local.name}-efs"

  encrypted      = false

  attach_policy = false

	# Mount targets / security group
  mount_targets              = { for k, v in zipmap(local.azs, module.vpc.private_subnets) : k => { subnet_id = v } }
  security_group_description = "${local.name} EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      type = "ingress"
      from_port         = 2049
      to_port           = 2049
      protocol          = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
    egress = {
      type = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "localnet-farm-efs" {
  value = module.efs.id
}

module "efs_hexcamp_coredns" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.3.1"

  name = "${local.name}-hexcamp-coredns"

  encrypted      = false

  attach_policy = false

	# Mount targets / security group
  mount_targets              = { for k, v in zipmap(local.azs, module.vpc.private_subnets) : k => { subnet_id = v } }
  security_group_description = "${local.name} EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      type = "ingress"
      from_port         = 2049
      to_port           = 2049
      protocol          = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
    egress = {
      type = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "efs-hexcamp-coredns" {
  value = module.efs_hexcamp_coredns.id
}
