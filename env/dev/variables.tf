locals {
  project_name     = "inaba"
  environment_name = "dev"
}

variable "aws_region" {
  description = "AWS_REGION"
  type        = string
}

variable "aws_profile" {
  description = "AWS_PROFILE"
  type        = string
}