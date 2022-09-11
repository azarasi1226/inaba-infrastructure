# 継承元ポリシー(初期でECSタスクにアタッチされるポリシー)
data "aws_iam_policy" "ecs_task_execution_role_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} 

# タスク実行ポリシー
data "aws_iam_policy_document" "ecs_task_execution" {
    source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

    statement {
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = ["*"]
    }
}

# タスク実行ロール
module "ecs_task_execution_role" {
    source = "../../modules/iam_role"

    resource_prefix = var.resource_prefix
    usage_name = "frontend-task-execution"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task_execution.json
}

# タスクポリシー
data "aws_iam_policy_document" "ecs_task" {
    statement {
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = ["*"]
    }
}

# タスクロール
module "ecs_task_role" {
    source = "../../modules/iam_role"

    resource_prefix = var.resource_prefix
    usage_name = "frontend-task"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task.json
}

# ECSタスク定義
resource "aws_ecs_task_definition" "this"{
    family = "${var.resource_prefix}-frontend-task"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu  = "256"
    memory = "512"

    container_definitions = file("${path.module}/task.json")

    task_role_arn = module.ecs_task_role.iam_role_arn
    execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}

# セキュリティグループ
module "frontend_sg" {
  source = "../../modules/security_group"

  resource_prefix = var.resource_prefix
  usage_name = "frontend"
  vpc_id = var.vpc_id
  port = "80"
  //TODO: 後で引数参照にする
  cidr_blocks = ["192.168.0.0/16"]
}

# ECSサービス
resource "aws_ecs_service" "this" {
    name = "${var.resource_prefix}-ecs-service"
    cluster = var.cluster_arn
    task_definition = aws_ecs_task_definition.this.arn
    desired_count = 3
    launch_type = "FARGATE"
    platform_version = "1.4.0"

    //ロードバランサーからのヘルスチェック猶予秒数
    //この時間が短いとTaskの起動に時間がかかった場合、起動と停止の無限ループに陥る
    //長すぎてもスケールを阻害するので1分とする
    //health_check_grace_period_seconds = 60

    network_configuration {
        assign_public_ip = false
        security_groups = [module.frontend_sg.security_group_id]
        subnets = var.container_private_subnet_ids
    }

    # load_balancer {
    #   target_group_arn = aws_lb_target_group.example.arn
    #   container_name = "example"
    #   container_port = 80
    # }

    lifecycle {
      ignore_changes = [task_definition]
    }
}