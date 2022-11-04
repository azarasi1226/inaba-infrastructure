variable "resource_prefix" {
  description = "リソース名につける識別用プレフィックス"
  type        = string
}

variable "github_user" {
  description = "GihutbのUserName"
  type        = string
}

variable "github_repository" {
  description = "GithubのRepositoryName"
  type        = string
}

variable "github_branch" {
  description = "CICDの対象ブランチ"
  type        = string
}

variable "ecs_cluster_name" {
  description = "cicd対象のECSクラスター名"
  type        = string
}

variable "ecs_service_name" {
  description = "cicd対象のECSサービス名"
  type        = string
}

variable "prod_listener_arn" {
  description = "本番環境のlisner arn"
  type        = string
}

variable "test_listener_arn" {
  description = "テスト環境のlisner arn"
  type        = string
}

variable "blue_targetgroup" {
  description = "blueTargetGroup"
  type        = string
}

variable "green_targetgroup" {
  description = "greenTargetGroup"
  type        = string
}