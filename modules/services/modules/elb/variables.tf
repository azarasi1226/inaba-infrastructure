variable "resource_prefix" {
  type        = string
}

variable "service_name" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "is_internal" {
  type = bool
}

variable "health_check_path" {
  type = string
}

//TODO: ポート番号とかヘルスチェック用のパスとかも外部から渡せるようにしないとあかんやろ