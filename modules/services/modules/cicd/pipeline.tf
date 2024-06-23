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

module "pipeline" {
  source = "../iam_role"

  resource_prefix = var.resource_prefix
  usage_name      = "${var.service_name}-pipeline"
  identifier      = "codepipeline.amazonaws.com"
  policy          = data.aws_iam_policy_document.pipeline.json
}

resource "aws_codepipeline" "this" {
  name     = "${var.resource_prefix}-${var.service_name}-pipline"
  role_arn = module.pipeline.iam_role_arn

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
        FullRepositoryId = "${var.github_user}/${var.github_repository}"
        BranchName       = var.github_branch
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
      version          = "1"
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
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.this.name
        DeploymentGroupName = aws_codedeploy_deployment_group.this.deployment_group_name
        # taskdef.json
        TaskDefinitionTemplateArtifact = "build_output"
        # appspec.yaml
        AppSpecTemplateArtifact = "build_output"
        # ImageDetail.json？
        Image1ArtifactName = "build_output"
        # taskdef.jsonで置き換えるImage名
        Image1ContainerName = "IMAGE1_NAME"
      }
    }
  }
}
