resource "aws_ecs_cluster" "this" {
  name = "${var.resource_prefix}-cluster"
}

module "network" {
  source = "./common/network"

  resource_prefix = var.resource_prefix
  vpc_cidr = var.network.vpc_cidr
  management_subnet_cidr = var.network.management_subnet_cidr
  ingress_subnet_cidrs = var.network.ingress_subnet_cidrs
  private_subnet_cidrs = var.network.private_subnet_cidrs
}

# module "bastion" {
#   source = "../../modules/bastion"

#   resource_prefix = local.resource_prefix
#   vpc_id          = module.network.vpc_id
#   subnet_id       = module.network.management_subnets_id
# }

# # フロントエンド
# module "frontend" {
#   source = "../../services/frontend"

#   resource_prefix              = local.resource_prefix
#   vpc_id                       = module.network.vpc_id
#   cluster_arn                  = aws_ecs_cluster.this.arn
#   cluster_name                 = aws_ecs_cluster.this.name
#   container_private_subnet_ids = module.network.container_private_subnet_ids
#   alb_public_subnet_ids        = module.network.ingress_public_subnet_ids
#   github_user                  = "azarasi1226"
#   github_repository            = "inaba-infra"
# }

# # バックエンド　
# module "backend" {
#   source = "../../services/backend"
# }