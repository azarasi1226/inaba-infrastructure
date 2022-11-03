resource "aws_ecs_cluster" "this" {
    name = "${var.resource_prefix}-cluster"
}