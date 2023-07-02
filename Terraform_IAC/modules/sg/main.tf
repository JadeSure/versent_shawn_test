# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "alb-sg" {
  name        = "petlover-alb-sg"
  description = "Inbound from Http and Https for ALB SG"
  vpc_id      = var.myapp_vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# this security group for ecs task - Traffic to the ECS cluster should only come from the ALB
# allowing ingress access only to the port that is exposed by the task.
resource "aws_security_group" "ecs_sg" {
  name        = "petlover-container-from-alb-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.myapp_vpc.id

  ingress {
    protocol = "tcp"
    # from_port       = 0
    # to_port         = 65535
    from_port = var.container_port
    to_port   = var.container_port

    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
