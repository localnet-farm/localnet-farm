terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.20"
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
