variable "resource_prefix" {
  default = "inaba"
}

# Githubとのコネクション
# CodePipelineのArtifact用S3
resource "aws_s3_bucket" "artifact" {
  bucket        = "${var.resource_prefix}-artifact-abcddfdsf"
  force_destroy = true
}

resource "aws_codestarconnections_connection" "this" {
  name          = "${var.resource_prefix}-github"
  provider_type = "GitHub"
}

# CodePipeline用ポリシー
data "aws_iam_policy_document" "pipeline" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:*",
      "codebuild:*",
      "codestar-connections:UseConnection",
    ]
  }
}

# CodePipeline用ロール
module "codepipline_role" {
  source = "../../modules/iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "pipeline"
  identifier      = "codepipeline.amazonaws.com"
  policy          = data.aws_iam_policy_document.pipeline.json
}

# CodePipeline
resource "aws_codepipeline" "this" {
  name     = "${var.resource_prefix}-cicd-pipline"
  role_arn = module.codepipline_role.iam_role_arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.artifact.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.this.arn
        FullRepositoryId = "azarasi1226/Inaba"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.this.id
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["source_output", "build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.this.name
        DeploymentGroupName = aws_codedeploy_deployment_group.this.deployment_group_name
        # taskdef.json
        TaskDefinitionTemplateArtifact = "source_output"
        # appspec.yaml
        AppSpecTemplateArtifact = "source_output"
        # ImageDetail.json？
        Image1ArtifactName = "build_output"
        # taskdef.jsonで置き換えるImage名
        Image1ContainerName = "IMAGE1_NAME"
      }
    }
  }
}

# CodeBuild
resource "aws_codebuild_project" "this" {
  name         = "${var.resource_prefix}-cicd-build"
  service_role = module.codebuild_role.iam_role_arn

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
    image        = "aws/codebuild/standard:2.0"

    # Dockerコマンドを許可
    privileged_mode = true
  }
}

# CodeBuild用ポリシー
data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      # s3
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      # ログ
      "logs:*",
    ]
  }
}

# CodeBuild用ロール
module "codebuild_role" {
  source = "../../modules/iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "codebuild"
  identifier      = "codebuild.amazonaws.com"
  policy          = data.aws_iam_policy_document.codebuild.json
}

# CodeDeployのアプリケーション
resource "aws_codedeploy_app" "this" {
  name = "${var.resource_prefix}-deploy-app"
}

# Deployグループ
resource "aws_codedeploy_deployment_group" "this" {
  deployment_group_name  = "${var.resource_prefix}-deploy-group"
  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = module.codebuild_role.iam_role_arn

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
}