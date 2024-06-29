module "entory" {
  source = "../../modules"

  resource_prefix = var.resource_prefix
  network         = local.network
  jump_server     = local.jump_server
}