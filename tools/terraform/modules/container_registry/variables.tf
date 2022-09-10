variable "resource_prefix" {
  description = "リソース名につける識別用プレフィックス"
  type = string
}

variable "service_name" {
    description = "サービス名"
    type = string
}

variable "can_destroy" {
    description = "間違ってterraform destoryできないようにします"
    type = bool
    default = true
}