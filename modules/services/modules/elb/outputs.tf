output "alb_arn" {
  value = aws_lb.this.arn
}

output "prod_listener_arn" {
  value = aws_lb_listener.prod.arn
}

output "test_listener_arn" {
  value = aws_lb_listener.test.arn
}

output "target_group_1_arn" {
  value = aws_lb_target_group.1.arn
}

output "target_group_1_name" {
  value = aws_lb_target_group.1.name
}

output "target_group_2_arn" {
  value = aws_lb_target_group.2.arn
}

output "target_group_2_name" {
  value = aws_lb_target_group.2.name
}