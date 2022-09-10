locals {
    //リソース名
    resource_name = "${var.resrouce_prefix}-${var.service-name}-ecr"
}

#ECR                     
resource "aws_ecr_repository" "this" {
    name = localresource_name
    force_delete = var.can_destroy


    lifecycle {
        create_before_destroy = true
    }
}