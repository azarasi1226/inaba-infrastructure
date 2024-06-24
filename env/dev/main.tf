locals {
  resource_prefix = "inaba-dev"
}

module "entory" {
  source = "../../modules"

  resource_prefix = local.resource_prefix
  network         = local.network
  jump_server     = local.jump_server
}

//sample
# module "jump_server" {
#   source = "../iam_role"

#   resource_prefix = var.resource_prefix
#   usage_name      = "jump-server"
#   identifier      = "ec2.amazonaws.com"
#   policy_json     = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = []
#         Resource = []
#       }
#     ]
#   })
# }