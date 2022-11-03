module "alb" {
    source = "../../modules/load_balancer"

    resource_prefix = var.resource_prefix
    service_name = local.service_name
    subnet_ids = var.alb_public_subnet_ids
    vpc_id = var.vpc_id
}