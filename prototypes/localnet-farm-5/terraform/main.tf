locals {
  name            = "localnet-farm-5"
  cluster_version = "1.30"
  #region          = "us-west-2"
  region          = "ca-central-1"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr = "10.0.0.0/16"

  tags = {
    lf-cluster = local.name
    GithubRepo = "localnet-farm"
    GithubOrg  = "jimpick"
  }
}

provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.name]
    command     = "aws"
  }
}