locals {
    resource_prefix = "momiji-dev"
}

# ネットワーク
module "network" {
  source = "../../modules/network"

    resource_prefix = local.resource_prefix
}

# コンテナ基盤
module "container_base" {
    source = "../../modules/container_base"

    resource_prefix = local.resource_prefix
}

# フロントエンド
module "frontend" {
    source = "../../services/frontend"
}

# バックエンド　
module "backend" {
    source = "../../services/backend"
}