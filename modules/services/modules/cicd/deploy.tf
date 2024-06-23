data "aws_iam_policy_document" "deploy" {
  statement {
    effect = "Allow"
    actions = [
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ModifyListener",
      "ecs:DescribeServices",
      "ecs:DeleteTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:CreateTaskSet",
      # TODO(IAM　権限絞る)
      "s3:*"
    ]
    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["iam:PassRole"]
    # TODO(IAM　権限絞る)
    resources = ["*"]
  }
}

module "deploy" {
  source = "../iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "deploy"
  identifier      = "codedeploy.amazonaws.com"
  policy          = data.aws_iam_policy_document.deploy.json
}

resource "aws_codedeploy_app" "this" {
  name             = "${var.resource_prefix}-${var.service_name}-deploy-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "this" {
  deployment_group_name  = "${var.resource_prefix}-${var.service_name}-deploy-group"
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = module.deploy_role.iam_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.prod_listener_arn]
      }

      test_traffic_route {
        listener_arns = [var.test_listener_arn]
      }

      target_group {
        name = var.target_group1_name
      }

      target_group {
        name = var.target_group2_name
      }
    }
  }
}