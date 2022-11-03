locals{
  service_name = "frontend"
}

# ECR
module "aws_ecr_repository" {
  source = "../../modules/container_registry"

  resource_prefix = var.resource_prefix
  service_name = local.service_name
}

# ECSタスク定義
resource "aws_ecs_task_definition" "this"{
    family = "${var.resource_prefix}-${local.service_name}-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu  = "256"
    memory = "512"

    container_definitions = templatefile("${path.module}/task.json", {
      service_name = local.service_name,
      image_url = module.aws_ecr_repository.repository_url
    })

    task_role_arn = module.ecs_task_role.iam_role_arn
    execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}

# ECSサービス
resource "aws_ecs_service" "this" {
    name = "${var.resource_prefix}-service"
    cluster = var.cluster_arn
    task_definition = aws_ecs_task_definition.this.arn
    desired_count = 3
    launch_type = "FARGATE"
    platform_version = "1.4.0"

    //ロードバランサーからのヘルスチェック猶予秒数
    //この時間が短いとTaskの起動に時間がかかった場合、起動と停止の無限ループに陥る
    //長すぎてもスケールを阻害するので1分とする
    # health_check_grace_period_seconds = 60

    network_configuration {
        assign_public_ip = false
        security_groups = [module.frontend_sg.security_group_id]
        subnets = var.container_private_subnet_ids
    }

    # load_balancer {
    #   target_group_arn = module.alb.arn
    #   container_name = local.service_name
    #   container_port = 80
    # }

    lifecycle {
      ignore_changes = [task_definition]
    }
}