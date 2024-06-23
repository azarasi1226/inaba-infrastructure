data "aws_iam_policy_document" "build" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "logs:*",
    ]
  }
}

module "build" {
  source = "../iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "${var.service_name}-build"
  identifier      = "codebuild.amazonaws.com"
  policy          = data.aws_iam_policy_document.codebuild.json
}

resource "aws_codebuild_project" "this" {
  name         = "${var.resource_prefix}-${var.service_name}-build"
  service_role = module.build.iam_role_arn

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    # TODO : machineイメージ調べる
    type         = "LINUX_CONTAINER"
    compute_type = "BUILD_GENERAL1_MEDIUM"
    image        = "aws/codebuild/standard:5.0"

    privileged_mode = true
  }
}