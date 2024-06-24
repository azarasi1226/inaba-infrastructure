variable "resource_prefix" {
  type        = string
}

variable "usage_name" {
  type        = string
}

variable "identifier" {
  description = "ロールを適応させたいIAMリソース識別子(例: codebuild.amazonaws.com)"
  type        = string
}

variable "policy_json" {
  type        = string
}