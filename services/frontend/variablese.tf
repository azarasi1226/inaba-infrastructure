variable "resource_prefix" {
  description = "リソース名につける識別用プレフィックス"
  type = string
}

variable "vpc_id" {
  description = "VPC_ID"
  type = string
}

variable "vpc_cidr" {
  description = "VPCのCIDR"
  type = string
}

variable "cluster_arn" {
    description = "ECSサービスを展開するECSクラスターARN"
    type = string
}

variable "cluster_name" {
  description = "CICDのDeploymentGroupの指定用クラスター名"
  type = string
}

variable "container_private_subnet_ids" {
    description = "コンテナを起動するサブネットのidリスト"
    type = list(string)
}

variable "alb_public_subnet_ids" {
    description = "アプリケーションロードバランサー用のサブネットのidリスト"
    type = list(string)
}

variable "github_user" {
  description = "Githubのユーザー名"
  type = string
}

variable "github_repository" {
  description = "Githubのレポジトリ名"
  type = string
}

variable "github_branch" {
  description = "CICD対象のブランチ名"
  type = string
  defulat = "main"
}