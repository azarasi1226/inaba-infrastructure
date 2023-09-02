# frontend

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
| <a name="module_alb"></a> [alb](#module\_alb) | ../../modules/load_balancer | n/a |
| <a name="module_aws_ecr_repository"></a> [aws\_ecr\_repository](#module\_aws\_ecr\_repository) | ../../modules/container_registry | n/a |
| <a name="module_ecs_task_execution_role"></a> [ecs\_task\_execution\_role](#module\_ecs\_task\_execution\_role) | ../../modules/iam_role | n/a |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | ../../modules/iam_role | n/a |
| <a name="module_frontend_cicd"></a> [frontend\_cicd](#module\_frontend\_cicd) | ../../modules/cicd | n/a |
| <a name="module_frontend_sg"></a> [frontend\_sg](#module\_frontend\_sg) | ../../modules/security_group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_public_subnet_ids"></a> [alb\_public\_subnet\_ids](#input\_alb\_public\_subnet\_ids) | アプリケーションロードバランサー用のサブネットのidリスト | `list(string)` | n/a | yes |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ECSサービスを展開するECSクラスターARN | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | CICDのDeploymentGroupの指定用クラスター名 | `string` | n/a | yes |
| <a name="input_container_private_subnet_ids"></a> [container\_private\_subnet\_ids](#input\_container\_private\_subnet\_ids) | コンテナを起動するサブネットのidリスト | `list(string)` | n/a | yes |
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | CICD対象のブランチ名 | `string` | `"main"` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Githubのレポジトリ名 | `string` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | Githubのユーザー名 | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | リソース名につける識別用プレフィックス | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC\_ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
