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
    usage_name = "${local.service_name}-task-execution"
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
    usage_name = "${local.service_name}-task"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task.json
}

# セキュリティグループ
module "frontend_sg" {
  source = "../../modules/security_group"

  resource_prefix = var.resource_prefix
  usage_name = "frontend"
  vpc_id = var.vpc_id
  port = "80"
  cidr_blocks = [var.vpc_cidr]
}