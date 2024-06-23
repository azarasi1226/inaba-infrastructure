locals {
  resource_prefix = "inaba-dev"
}

module "entory" {
  source = "../../modules/common/network"

  resource_prefix = local.resource_prefix
  vpc_cidr = var.network.vpc_cidr
  management_subnet_cidr = var.network.management_subnet_cidr
  ingress_subnet_cidrs = var.network.ingress_subnet_cidrs
  private_subnet_cidrs = var.network.private_subnet_cidrs
}