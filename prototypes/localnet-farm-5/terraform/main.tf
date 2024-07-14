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

