output "back_tg" {
    value = aws_lb_target_group.back_tg
}

output "https_listener"{
    value = aws_lb_listener.https
}

output "aws_lb" {
    value = aws_lb.back_lb
}