# cicd

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
| <a name="module_codebuild_role"></a> [codebuild\_role](#module\_codebuild\_role) | ../iam_role | n/a |
| <a name="module_codepipline_role"></a> [codepipline\_role](#module\_codepipline\_role) | ../iam_role | n/a |
| <a name="module_deploy_role"></a> [deploy\_role](#module\_deploy\_role) | ../iam_role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codedeploy_app.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codepipeline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_s3_bucket.artifact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_iam_policy_document.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blue_targetgroup_name"></a> [blue\_targetgroup\_name](#input\_blue\_targetgroup\_name) | blueTargetGroup | `string` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | cicd対象のECSクラスター名 | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | cicd対象のECSサービス名 | `string` | n/a | yes |
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | CICDの対象ブランチ | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GithubのRepositoryName | `string` | n/a | yes |
| <a name="input_github_user"></a> [github\_user](#input\_github\_user) | GihutbのUserName | `string` | n/a | yes |
| <a name="input_green_targetgroup_name"></a> [green\_targetgroup\_name](#input\_green\_targetgroup\_name) | greenTargetGroup | `string` | n/a | yes |
| <a name="input_prod_listener_arn"></a> [prod\_listener\_arn](#input\_prod\_listener\_arn) | 本番環境のlisner arn | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | リソース名につける識別用プレフィックス | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | サービス名 | `string` | n/a | yes |
| <a name="input_test_listener_arn"></a> [test\_listener\_arn](#input\_test\_listener\_arn) | テスト環境のlisner arn | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
