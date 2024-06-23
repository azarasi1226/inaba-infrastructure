variable "resource_prefix" {
  type        = string
}

variable "service_name" {
  type        = string
}

variable "github_user" {
  type        = string
}

variable "github_repository" {
  type        = string
}

variable "github_branch" {
  type        = string
}

variable "ecs_cluster_name" {
  type        = string
}

variable "ecs_service_name" {
  type        = string
}

variable "prod_listener_arn" {
  type        = string
}

variable "test_listener_arn" {
  type        = string
}

variable "target_group1_name" {
  type        = string
}

variable "target_group2_name" {
  type        = string
}