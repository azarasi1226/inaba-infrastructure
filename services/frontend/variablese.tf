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
    description = "ECSクラスターARN"
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