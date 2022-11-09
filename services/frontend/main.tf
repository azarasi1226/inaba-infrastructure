locals {
  service_name = "frontend"
}

module "alb" {
  source = "../../modules/load_balancer"

  resource_prefix = var.resource_prefix
  service_name    = local.service_name
  subnet_ids      = var.alb_public_subnet_ids
  vpc_id          = var.vpc_id
}

# ----------------------------------------------------------------------------------------
# 継承元ポリシー(初期でECSタスクにアタッチされるポリシー)
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# タスク実行ポリシー
data "aws_iam_policy_document" "ecs_task_execution" {
  source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup"
    ]
  }
}

# タスク実行ロール
module "ecs_task_execution_role" {
  source = "../../modules/iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "${local.service_name}-task-execution"
  identifier      = "ecs-tasks.amazonaws.com"
  policy          = data.aws_iam_policy_document.ecs_task_execution.json
}

# タスクポリシー
data "aws_iam_policy_document" "ecs_task" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup"
    ]
  }
}

# タスクロール
module "ecs_task_role" {
  source = "../../modules/iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "${local.service_name}-task"
  identifier      = "ecs-tasks.amazonaws.com"
  policy          = data.aws_iam_policy_document.ecs_task.json
}

# セキュリティグループ
module "frontend_sg" {
  source = "../../modules/security_group"

  resource_prefix = var.resource_prefix
  usage_name      = "frontend"
  vpc_id          = var.vpc_id
  port            = "80"
  cidr_blocks     = ["0.0.0.0/0"]
}

# ----------------------------------------------------------------------------------------
# ECR
module "aws_ecr_repository" {
  source = "../../modules/container_registry"

  resource_prefix = var.resource_prefix
  service_name    = local.service_name
}

# ECSタスク定義
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.resource_prefix}-${local.service_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = templatefile("${path.module}/task.json", {
    service_name = local.service_name,
    image_url    = module.aws_ecr_repository.repository_url
  })

  task_role_arn      = module.ecs_task_role.iam_role_arn
  execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}

# ECSサービス
resource "aws_ecs_service" "this" {
  name             = "${var.resource_prefix}-${local.service_name}-service"
  cluster          = var.cluster_arn
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = 3
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  //ロードバランサーからのヘルスチェック猶予秒数
  //この時間が短いとTaskの起動に時間がかかった場合、起動と停止の無限ループに陥る
  //長すぎてもスケールを阻害するので1分とする
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.frontend_sg.security_group_id]
    subnets          = var.container_private_subnet_ids
  }

  load_balancer {
    target_group_arn = module.alb.blue_targetgroup_arn
    container_name   = local.service_name
    container_port   = 8080
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

# ----------------------------------------------------------------------------------------
# CICD
module "frontend_cicd" {
  source = "../../modules/cicd"

  resource_prefix   = var.resource_prefix
  service_name      = local.service_name
  github_user       = var.github_user
  github_repository = var.github_repository
  github_branch     = var.github_branch
  ecs_cluster_name  = var.cluster_name
  ecs_service_name  = aws_ecs_service.this.name
  prod_listener_arn = module.alb.prod_listener_arn
  test_listener_arn = module.alb.test_listener_arn
  blue_targetgroup_name  = module.alb.blue_targetgroup_name
  green_targetgroup_name = module.alb.green_targetgroup_name
}