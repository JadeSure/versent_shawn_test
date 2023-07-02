output "s3_OAC_policy" {
  value = data.aws_iam_policy_document.s3_OAC_policy
}

# output "ecs_task_role" {
#   value = aws_iam_role.ecs_task_role
# }

# output "ecs_task_execution_role"{
#   value = aws_iam_role.ecs_task_execution_role
# }