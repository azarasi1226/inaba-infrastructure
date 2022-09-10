# 継承元ポリシー(初期でECSタスクにアタッチされるポリシー)
data "aws_iam_policy" "ecs_task_execution_role_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} 

# 派生ポリシー
data "aws_iam_policy_document" "ecs_task_execution" {
    source_policy_documents = [data.aws_iam_policy.ecs_task_execution_role_policy.policy]

    statement {
      effect = "Allow"
      actions = [

      ]
      resources = ["*"]
    }
}

# IAMロール
module "ecs_task_execution_role" {
    source = "../../modules/iam_role"
    role_name = "ecs-task-execution"
    identifier = "ecs-tasks.amazonaws.com"
    policy = data.aws_iam_policy_document.ecs_task_execution.json
}

# ECSタスク定義
resource "aws_ecs_task_definition" "this"{
    family = "example"
    cpu  = "256"
    memory = "512"
    //Fargateの場合ネットワークモードは固定される
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    container_definitions = file("./container_definitions.json")

    execution_role_arn = module.ecs_task_execution_role.iam_role_arn
}