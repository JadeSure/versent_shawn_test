
resource "aws_lb" "back_lb" {
#   count = length(var.myapp_public_subnet.public)
  name               = "ECS-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg.id]
#   subnets = [element(var.myapp_public_subnet.public.*.id, count.index)]
  subnets            = [for subnet in var.myapp_public_subnet : subnet.id]

  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "${var.deploy_env}-lb"
  }
}


resource "aws_lb_target_group" "back_tg" {
  name        = "myecs-tg"
  target_type = "ip"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.myapp_vpc.id

  health_check {
    # healthy_threshold   = 2
    # unhealthy_threshold = 2
    timeout             = 20
    protocol            = "HTTP"
    matcher             = "200-399"
    path                = var.health_check_path
    interval            = 60
  }
  tags = {
    Environment = "${var.deploy_env}-tg"
  }
}

# resource "aws_lb_listener_certificate" "listener_certificate" {
#   listener_arn    = aws_lb_listener.front_end_listener.arn
#   certificate_arn = data.aws_acm_certificate.issued.arn
# }

# one for HTTP and one for HTTPS, where the HTTP listener redirects to the HTTPS listener,
#  which funnels traffic to the target group.
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.back_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = {
    Environment = "${var.deploy_env}-http"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.back_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = data.aws_acm_certificate.issued.arn
  certificate_arn = var.acm_certificate_Sydney_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back_tg.arn
  }

  tags = {
    Environment = "${var.deploy_env}-https"
  }
}

