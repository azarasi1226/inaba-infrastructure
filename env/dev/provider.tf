terraform {
  required_version = "~> 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
  }
}

provider "aws" {
  region  = local.aws_region
  profile = var.aws_profile
}