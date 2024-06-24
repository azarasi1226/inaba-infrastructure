locals {
  resource_prefix = "inaba-dev"
}

module "entory" {
  source = "../../modules"

  resource_prefix = local.resource_prefix
  network         = local.network
  jump_server     = local.jump_server
}