terraform {
  required_version = "~> 1.3.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
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