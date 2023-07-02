# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "cb_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.my-cluster.name
    ServiceName = aws_ecs_service.my-service.name
  }

    alarm_description = "This metric monitors ecs container cpu utilization"
  alarm_actions = [aws_appautoscaling_policy.up.arn]

  tags ={
    Name = "${var.deploy_env}-scale-up"
  }
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "cb_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.my-cluster.name
    ServiceName = aws_ecs_service.my-service.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]

  tags ={
    Name = "${var.deploy_env}-scale-down"
  }
}