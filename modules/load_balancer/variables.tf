variable "resource_prefix" {
  description = "リソース名につける識別用プレフィックス"
  type        = string
}

variable "service_name" {
  description = "ロードバランサーを適応させたいサービス名"
  type        = string
}

variable "subnet_ids" {
  description = "ロードバランサーを配置したいサブネットのIDリスト"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC_ID"
  type        = string
}

//TODO: ポート番号とかヘルスチェック用のパスとかも外部から渡せるようにしないとあかんやろ