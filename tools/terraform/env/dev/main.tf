locals {
    resource_prefix = "momiji-dev"
}

module "network" {
  source = "../../modules/network"

    resource_prefix = local.resource_prefix
}

module "container_base" {
    source = "../../modules/container_base"

    resource_prefix
}