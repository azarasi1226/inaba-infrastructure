resource "aws_ecs_cluster" "this" {
    naem = "${var.resrouce_prefix}-cluster"
}