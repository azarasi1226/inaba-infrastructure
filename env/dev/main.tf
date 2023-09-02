locals {
  resource_prefix = "inaba-dev"
}

# ネットワーク
module "network" {
  source = "../../modules/network"

  resource_prefix = local.resource_prefix
}

# 各サービスを管理するECSクラスター
resource "aws_ecs_cluster" "this" {
  name = "${local.resource_prefix}-cluster"
}

# 踏み台サーバー
module "bastion" {
  source = "../../modules/bastion"

  resource_prefix = local.resource_prefix
  vpc_id          = module.network.vpc_id
  subnet_id       = module.network.management_subnets_id
}

# フロントエンド
module "frontend" {
  source = "../../services/frontend"

  resource_prefix              = local.resource_prefix
  vpc_id                       = module.network.vpc_id
  cluster_arn                  = aws_ecs_cluster.this.arn
  cluster_name                 = aws_ecs_cluster.this.name
  container_private_subnet_ids = module.network.container_private_subnet_ids
  alb_public_subnet_ids        = module.network.ingress_public_subnet_ids
  github_user                  = "azarasi1226"
  github_repository            = "inaba-infra"
}

# バックエンド　
module "backend" {
  source = "../../services/backend"
}