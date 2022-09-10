module "network" {
    source = "../../modules/network"

    project_name = local.project_name
    environment_name = local.environment_name
}