# load_balancer

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_http_sg"></a> [http\_sg](#module\_http\_sg) | ../security_group | n/a |
| <a name="module_https_sg"></a> [https\_sg](#module\_https\_sg) | ../security_group | n/a |
| <a name="module_test_sg"></a> [test\_sg](#module\_test\_sg) | ../security_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | リソース名につける識別用プレフィックス | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | ロードバランサーを適応させたいサービス名 | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | ロードバランサーを配置したいサブネットのIDリスト | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC\_ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | n/a |
| <a name="output_blue_targetgroup_arn"></a> [blue\_targetgroup\_arn](#output\_blue\_targetgroup\_arn) | n/a |
| <a name="output_blue_targetgroup_name"></a> [blue\_targetgroup\_name](#output\_blue\_targetgroup\_name) | n/a |
| <a name="output_green_targetgroup_arn"></a> [green\_targetgroup\_arn](#output\_green\_targetgroup\_arn) | n/a |
| <a name="output_green_targetgroup_name"></a> [green\_targetgroup\_name](#output\_green\_targetgroup\_name) | n/a |
| <a name="output_prod_listener_arn"></a> [prod\_listener\_arn](#output\_prod\_listener\_arn) | n/a |
| <a name="output_test_listener_arn"></a> [test\_listener\_arn](#output\_test\_listener\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
