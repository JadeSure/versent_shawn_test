resource "aws_cloudwatch_log_group" "ecs_fargate" {
  name              = "/ecs/cb-app"
  retention_in_days = 7

  tags = {
    Name = "${var.deploy_env}-cb-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "cb_log_stream" {
  name           = "cb-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_fargate.name

}

