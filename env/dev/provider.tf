terraform {
  required_version = "~> 1.3.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      // Providerに対するバージョン制約
      version = "~> 4.37.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment  = local.environment_name
      Project_Name = local.project_name
    }
  }
}