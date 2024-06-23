locals {
  resource_name = "${var.resource_prefix}-${var.service_name}"
}

# ------------------------------------------------------------------------------
# CodePipelineのArtifact用S3
resource "aws_s3_bucket" "artifact" {
  bucket        = "${local.resource_name}-artifact"
  force_destroy = true
}

# 100日でS3内のArtifactが削除されるように
resource "aws_s3_bucket_lifecycle_configuration" "name" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    status = "Enabled"
    id     = "lifcycle-rule"

    expiration {
      days = "100"
    }
  }
}

# ------------------------------------------------------------------------------
# Githubとのコネクション
resource "aws_codestarconnections_connection" "this" {
  name          = "${local.resource_name}-github"
  provider_type = "GitHub"
}