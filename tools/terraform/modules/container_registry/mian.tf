locals {
    //リソース名
    resource_name = "${var.resource_prefix}-${var.service_name}-ecr"
}

#ECR                     
resource "aws_ecr_repository" "this" {
    name = local.resource_name
    //tag名はgitのコミット番号とするので上書きさせない
    image_tag_mutability = "IMMUTABLE"
    //脆弱性のスキャン
    image_scanning_configuration {
        scan_on_push = true
    }
}

//TODO ライフサイクルポリシー