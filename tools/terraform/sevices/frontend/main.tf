# 継承元ポリシー
data "aws_iam_policy" "ecs_task_execution_role_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} 

# 独自ポリシーとIAMロール作成
data "aws_iam_policy_document" "ecs_task_execution" {
    source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

    statement {
      effect = "Allow"
      actions = [
        "ssm:GetParameters", 
        "kms:Decrypt"
        ]
      resources = ["*"]
    }
}
module "ecs_task_execution_role" {
    source = "./modules/iam_role"
    name = "ecs-task-execution"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task_execution.json
}