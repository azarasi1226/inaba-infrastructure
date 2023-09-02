terraform {
  required_version = "~> 1.5.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.15.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Environment  = local.environment_name
      Project_Name = local.project_name
    }
  }
}