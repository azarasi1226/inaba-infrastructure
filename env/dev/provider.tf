terraform {
  required_version = "~> 1.3.4"
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