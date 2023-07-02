# obtain current account ID
data "aws_caller_identity" "current" {}

# obtain aws managed policy ecsTaskExecutionRole
data "aws_iam_policy" "ecsTaskExecutionRolePolicy" {
   name = "AmazonECSTaskExecutionRolePolicy"
  #  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_TR"{
   statement {
    # attention: the name of sid cannot have '-'
    sid = "ecstrustTR"
    
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.deploy_env}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_TR.json
}


resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role = aws_iam_role.ecs_task_execution_role.name
  #   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  policy_arn = data.aws_iam_policy.ecsTaskExecutionRolePolicy.arn
}



# ecs read secret manager and to connect with SSM Session Manager service
data "aws_iam_policy_document" "ECS_SM_SSM" {
  statement {
    sid = "AllowECSReadSecretManagerOnly"

    actions = [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ]

    resources = [
      "arn:aws:secretsmanager:ap-southeast-2:${data.aws_caller_identity.current.account_id}:secret:uat-petlover-back-lxTPJy",
    ]
  }

  statement {
    actions = ["secretsmanager:ListSecrets"]
    resources = [
      "*",
    ]
  }

  statement {
    actions = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel"
       ]
       
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecsSMTaskRolePolicy" {
   name = "AccessSMECSTaskRolePolicy"
   policy = data.aws_iam_policy_document.ECS_SM_SSM.json
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.deploy_env}-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_TR.json
}


resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecsSMTaskRolePolicy.arn
}
