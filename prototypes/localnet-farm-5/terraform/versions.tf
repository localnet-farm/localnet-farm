terraform {
  backend "remote" {
    organization = "hex-camp"
    workspaces {
      name = "localnet-farm-5"
    }
  }

  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.11"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }
  }
}
