locals {
  resource_name = "${var.resource_prefix}-${var.usage_name}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${local.resource_name}-policy"
  policy = var.policy_json
}

resource "aws_iam_role" "this" {
  name               = "${local.resource_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}