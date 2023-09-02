# dev

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | ../../services/backend | n/a |
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../../modules/bastion | n/a |
| <a name="module_frontend"></a> [frontend](#module\_frontend) | ../../services/frontend | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/network | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS\_PROFILE | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS\_REGION | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
