module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                    = local.name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  #cluster_additional_security_group_ids = [aws_security_group.eks.id]

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni    = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
    aws-efs-csi-driver = {
      most_recent = true
    }
  }

  cluster_enabled_log_types = []

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Fargate profiles use the cluster primary security group so these are not utilized
  #create_cluster_security_group = false
  #create_node_security_group    = false

	eks_managed_node_group_defaults = {
		#ami_type = "AL2_x86_64"
		#ami_type = "BOTTLEROCKET_x86_64"

		attach_cluster_primary_security_group = true

		# Disabling and using externally provided security groups
		#create_security_group = false

    # https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1845#issuecomment-1054248734

    #ami_type              = "BOTTLEROCKET_x86_64"
    ami_type              = "BOTTLEROCKET_ARM_64"
    platform              = "bottlerocket"

    # https://instances.vantage.sh/aws/ec2/c6a.2xlarge?region=us-west-2&cost_duration=monthly&os=linux&reserved_term=Standard.noUpfront
		#instance_types = ["c6a.2xlarge"] # 8vCPUs, 18GiB, AMD, $223.38/mth

    # https://instances.vantage.sh/aws/ec2/m6a.large?region=us-west-2&cost_duration=monthly&os=linux&reserved_term=Standard.noUpfront
    #instance_types = ["m6a.large"] # 2vCPUs, 8GiB, AMD, $63.07/mth
    #instance_types = ["t2.small"] # 1vCPUs, 2GiB, $16.79/mth
    #instance_types = ["t3.small"] # 1vCPUs, 2GiB, $15.18/mth
    #instance_types = ["t3a.small"] # 2vCPUs, 2GiB, $13.72/mth

    # https://instances.vantage.sh/aws/ec2/t3a.xlarge?selected=m6a.large&region=us-east-1&os=linux&cost_duration=monthly&reserved_term=Standard.noUpfront
    # instance_types = ["t3a.xlarge"] # 4vCPUs, 16GiB, $109.79/mth

    #instance_types = ["t3a.large"] # AMD, 2vCPUs, 8GiB, $54.896/mth, $21.973/mth spot
    # us-west-2 spot prices 2024-01-01
    # us-west-2a $0.0315
    # us-west-2b $0.0309
    # us-west-2c $0.0346
    # us-west-2d $0.0253

    # https://instances.vantage.sh/aws/ec2/t4g.large?region=us-east-1&os=linux&cost_duration=monthly&reserved_term=Standard.noUpfront
    instance_types = ["t4g.large"] # Graviton, 2vCPUs, 8GiB, $49.056/mth, $23.068/mth spot
    # us-west-2 spot prices 2024-01-01
    # us-west-2a $0.0245
    # us-west-2b $0.0227
    # us-west-2c $0.0276
    # us-west-2d $0.0228

    # ca-central-1a $0.0176
    # ca-central-1b $0.0221
    # ca-central-1d $0.0098

    #capacity_type = "SPOT"
    capacity_type = "ON_DEMAND"

    # Force gp3 & encryption (https://github.com/bottlerocket-os/bottlerocket#default-volumes)
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs         = {
          volume_size           = 2
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = false
          delete_on_termination = true
        }
      }
      xvdb = {
        device_name = "/dev/xvdb"
        ebs         = {
          volume_size           = 80
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = false
          delete_on_termination = true
        }
      }
    }
	}

	eks_managed_node_groups = {
		admin = {
			name = "node-group-admin"

      subnet_ids = [module.vpc.public_subnets[2]]

			#instance_types = ["c6a.2xlarge"]

			min_size     = 1
			max_size     = 1
			desired_size = 1

      enable_monitoring = false

      #use_custom_launch_template = false

      #disk_size = 80

      # https://www.reddit.com/r/Terraform/comments/znomk4/ebs_csi_driver_entirely_from_terraform_on_aws_eks/
      # https://github.com/ElliotG/coder-oss-tf/blob/main/aws-eks/main.tf
      # Needed by the aws-ebs-csi-driver
      # EFS: https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }

      vpc_security_group_ids = [aws_security_group.eks.id]

      key_name = "jim-ca-central-1"
      source_security_group_ids = [aws_security_group.eks.id]
		}
	}

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        { namespace = "default" }
      ]

      # Using specific subnets instead of the subnets supplied for the cluster itself
      subnet_ids = [module.vpc.private_subnets[2]]

      tags = {
				lf-cluster = local.name
				GithubRepo = "localnet-farm"
				GithubOrg  = "jimpick"
      }

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }

    kourier_system = {
      name = "kourier-system"
      selectors = [
        { namespace = "kourier-system" }
      ]

      # Using specific subnets instead of the subnets supplied for the cluster itself
      subnet_ids = [module.vpc.private_subnets[2]]

      tags = {
        lf-cluster = local.name
        GithubRepo = "localnet-farm"
        GithubOrg  = "jimpick"
      }
    }
  }

  tags = local.tags
}
