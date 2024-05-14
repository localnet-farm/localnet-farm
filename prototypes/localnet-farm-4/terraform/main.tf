provider "aws" {
  region = local.region
}

#provider "helm" {
#  kubernetes {
#    host                   = module.eks.cluster_endpoint
#    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#
#    exec {
#      api_version = "client.authentication.k8s.io/v1beta1"
#      command     = "aws"
#      # This requires the awscli to be installed locally where Terraform is executed
#      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
#    }
#  }
#}

locals {
  name            = "localnet-farm-4"
  cluster_version = "1.26"
  region          = "us-west-2"

  tags = {
    lf-cluster = local.name
    GithubRepo = "localnet-farm"
    GithubOrg  = "jimpick"
  }
}

################################################################################
# EKS Module
################################################################################

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
  }

  #cluster_encryption_config = [{
  #  provider_key_arn = aws_kms_key.eks.arn
  #  resources        = ["secrets"]
  #}]

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

    ami_type              = "BOTTLEROCKET_x86_64"
    platform              = "bottlerocket"

    # https://instances.vantage.sh/aws/ec2/c6a.2xlarge?region=us-west-2&cost_duration=monthly&os=linux&reserved_term=Standard.noUpfront
		#instance_types = ["c6a.2xlarge"] # 8vCPUs, 18GiB, AMD, $223.38/mth

    # https://instances.vantage.sh/aws/ec2/m6a.large?region=us-west-2&cost_duration=monthly&os=linux&reserved_term=Standard.noUpfront
    instance_types = ["m6a.large"] # 2vCPUs, 8GiB, AMD, $63.07/mth



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

			#instance_types = ["c6a.2xlarge"]

			min_size     = 1
			max_size     = 1
			desired_size = 1

      #use_custom_launch_template = false

      #disk_size = 80

      # https://www.reddit.com/r/Terraform/comments/znomk4/ebs_csi_driver_entirely_from_terraform_on_aws_eks/
      # https://github.com/ElliotG/coder-oss-tf/blob/main/aws-eks/main.tf
      # Needed by the aws-ebs-csi-driver
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }
		}
	}

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        { namespace = "default" }
      ]

      # Using specific subnets instead of the subnets supplied for the cluster itself
      subnet_ids = [module.vpc.private_subnets[1]]

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
      subnet_ids = [module.vpc.private_subnets[1]]

      tags = {
        lf-cluster = local.name
        GithubRepo = "localnet-farm"
        GithubOrg  = "jimpick"
      }
    }
  }

  tags = local.tags
}

################################################################################
# Modify EKS CoreDNS Deployment
################################################################################

#data "aws_eks_cluster_auth" "this" {
#  name = module.eks.cluster_id
#}
#
#locals {
#  kubeconfig = yamlencode({
#    apiVersion      = "v1"
#    kind            = "Config"
#    current-context = "terraform"
#    clusters = [{
#      name = module.eks.cluster_id
#      cluster = {
#        certificate-authority-data = module.eks.cluster_certificate_authority_data
#        server                     = module.eks.cluster_endpoint
#      }
#    }]
#    contexts = [{
#      name = "terraform"
#      context = {
#        cluster = module.eks.cluster_id
#        user    = "terraform"
#      }
#    }]
#    users = [{
#      name = "terraform"
#      user = {
#        token = data.aws_eks_cluster_auth.this.token
#      }
#    }]
#  })
#}

# Separate resource so that this is only ever executed once
#resource "null_resource" "remove_default_coredns_deployment" {
#  triggers = {}
#
#  provisioner "local-exec" {
#    interpreter = ["/bin/bash", "-c"]
#    environment = {
#      KUBECONFIG = base64encode(local.kubeconfig)
#    }
#
#    # We are removing the deployment provided by the EKS service and replacing it through the self-managed CoreDNS Helm addon
#    # However, we are maintaing the existing kube-dns service and annotating it for Helm to assume control
#    command = <<-EOT
#      curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl
#      ./kubectl --namespace kube-system delete deployment coredns --kubeconfig <(echo $KUBECONFIG | base64 --decode)
#    EOT
#  }
#}

resource "null_resource" "modify_kube_dns" {
  triggers = {}

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = base64encode(local.kubeconfig)
    }

    # We are maintaing the existing kube-dns service and annotating it for Helm to assume control
    command = <<-EOT
      echo "Setting implicit dependency on ${module.eks.fargate_profiles["default"].fargate_profile_pod_execution_role_arn}"
      curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl
      ./kubectl --namespace kube-system annotate --overwrite service kube-dns meta.helm.sh/release-name=coredns --kubeconfig <(echo $KUBECONFIG | base64 --decode)
      ./kubectl --namespace kube-system annotate --overwrite service kube-dns meta.helm.sh/release-namespace=kube-system --kubeconfig <(echo $KUBECONFIG | base64 --decode)
      ./kubectl --namespace kube-system label --overwrite service kube-dns app.kubernetes.io/managed-by=Helm --kubeconfig <(echo $KUBECONFIG | base64 --decode)
    EOT
  }

  depends_on = [
    null_resource.remove_default_coredns_deployment
  ]
}

################################################################################
# CoreDNS Helm Chart (self-managed)
################################################################################

data "aws_eks_addon_version" "this" {
  for_each = toset(["coredns"])

  addon_name         = each.value
  kubernetes_version = module.eks.cluster_version
  most_recent        = true
}

#resource "helm_release" "coredns" {
#  name             = "coredns"
#  namespace        = "kube-system"
#  create_namespace = false
#  description      = "CoreDNS is a DNS server that chains plugins and provides Kubernetes DNS Services"
#  chart            = "coredns"
#  version          = "1.19.4"
#  repository       = "https://coredns.github.io/helm"
#
#  # For EKS image repositories https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
#  values = [
#    <<-EOT
#      image:
#        repository: 602401143452.dkr.ecr.us-west-2.amazonaws.com/eks/coredns
#        tag: ${data.aws_eks_addon_version.this["coredns"].version}
#      deployment:
#        name: coredns
#        annotations:
#          eks.amazonaws.com/compute-type: fargate
#      service:
#        name: kube-dns
#        annotations:
#          eks.amazonaws.com/compute-type: fargate
#      podAnnotations:
#        eks.amazonaws.com/compute-type: fargate
#      EOT
#  ]
#
#  depends_on = [
#    # Need to ensure the CoreDNS updates are peformed before provisioning
#    null_resource.modify_kube_dns
#  ]
#}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

  tags = local.tags
}

resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = local.tags
}

# Load balancer
# https://andrewtarry.com/posts/terraform-eks-alb-setup/

resource "aws_security_group" "eks" {
  name        = "${local.name} eks cluster"
  description = "Allow traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "World"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  #tags = merge({
  #       Name = "EKS ${local.name}",
  #       "kubernetes.io/cluster/${local.eks_name}": "owned"
  #}, var.tags)
}

module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.name}_eks_lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.name]
    command     = "aws"
  }
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
  secret {
    name = "${kubernetes_secret.localnet_farm.metadata.0.name}"
  }
}

resource "kubernetes_secret" "localnet_farm" {
  metadata {
    name = "localnet-farm-secret"
  }
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = local.region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-west-2.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = local.name
  }
}

# IRSA role for EBS
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
# https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/examples/iam-role-for-service-accounts-eks/main.tf
# https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html

#module "ebs_csi_irsa_role" {
#  source = "../../modules/iam-role-for-service-accounts-eks"
#  source  = "terraform-aws-modules/eks/aws"
#  version = "~> 18.0"
#
#  #role_name             = "ebs-csi"
#  attach_ebs_csi_policy = true
#
#  oidc_providers = {
#    ex = {
#      provider_arn               = module.eks.oidc_provider_arn
#      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
#    }
#  }
#
#  tags = local.tags
#}
