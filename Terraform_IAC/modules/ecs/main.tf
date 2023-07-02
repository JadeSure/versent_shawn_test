locals {
  application_name = "${var.deploy_env}-cluster"
  launch_type = "FARGATE"
}

data "aws_secretsmanager_secret_version" "container_secret" {
  secret_id = var.sm_secret_id 
}


resource "aws_ecs_cluster" "my-cluster" {
  name = local.application_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "my-def" {
  family                   = "${var.deploy_env}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["${local.launch_type}"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory

  container_definitions = jsonencode([{
    name = "${var.deploy_env}-container"
    image = "${var.ecr_repository_url}:latest"
    essential = true

    # clear the SSM agent and its child processes that may become zombies
    initProcessEnabled = true
    
    # secrets = [
    #   {
    #     "name" : "JWT_KEY",
    #     "valueFrom": "arn:aws:secretsmanager:ap-southeast-2:046381260578:secret:uat-petlover-back-lxTPJy:JWT_KEY::"
    #   },
    #   {
    #     "name": "CONNECTION_STRING",
    #     "valueFrom": "arn:aws:secretsmanager:ap-southeast-2:046381260578:secret:uat-petlover-back-lxTPJy:CONNECTION_STRING::"
    #   }
    # ]
    "environment": [
      { 
        "name" : "PORT", 
        "value" : jsondecode(data.aws_secretsmanager_secret_version.container_secret.secret_string)["PORT"]
      },
      {
       "name" : "API_PREFIX", 
       "value" : jsondecode(data.aws_secretsmanager_secret_version.container_secret.secret_string)["API_PREFIX"]
      },
      {
        "name" : "NODE_ENV", 
        "value" : jsondecode(data.aws_secretsmanager_secret_version.container_secret.secret_string)["NODE_ENV"]
      },
      {
        "name" : "USERNAME", 
        "value" : jsondecode(data.aws_secretsmanager_secret_version.container_secret.secret_string)["USERNAME"]
      },
      {
        "name" : "PASSWORD", 
        "value" : jsondecode(data.aws_secretsmanager_secret_version.container_secret.secret_string)["PASSWORD"]
      }
      ]

    portMappings = [{
      # protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]

    "logConfiguration": {
    "logDriver": "awslogs",
    "options": { 
      "awslogs-group": "${aws_cloudwatch_log_group.ecs_fargate.name}",  
      "awslogs-region": "ap-southeast-2",
      "awslogs-stream-prefix": "ecs"
    }
  }
  }])

  tags = {
    Name : "${var.deploy_env}-task-df"
  }
}

resource "aws_ecs_service" "my-service" {
  name            = "${var.deploy_env}-service"
  cluster         = aws_ecs_cluster.my-cluster.id
  task_definition = aws_ecs_task_definition.my-def.arn

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  desired_count                      = var.desired_tasks_num

  health_check_grace_period_seconds = 60

  launch_type         = local.launch_type
  scheduling_strategy = "REPLICA"

  # allow access to container from the outside
  enable_execute_command = true


  network_configuration {
    security_groups  = [var.ecs_sg.id]
    subnets          = var.ecs_container_subnet.*.id
    assign_public_ip = true
  }

   force_new_deployment = true

  load_balancer {
    target_group_arn = var.aws_alb_target_group.arn
    container_name   = "${var.deploy_env}-container"
    container_port   = var.container_port
  }

  # lifecycle {
  #   ignore_changes = [task_definition, desired_count]
  # }

  depends_on = [
    aws_iam_role.ecs_task_role,
    aws_iam_role.ecs_task_execution_role
  ]

   tags = {
    Name : "${var.deploy_env}-ecs-service"
  }
}