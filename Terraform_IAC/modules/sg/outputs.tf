output "alb_sg" {
  value = aws_security_group.alb-sg
}

output "ecs_sg" {
  value = aws_security_group.ecs_sg
}