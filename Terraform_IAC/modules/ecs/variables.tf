variable "deploy_env" {
  
}

# container definition
variable "container_cpu" {}
variable "container_memory" {}
variable "container_port" {}
variable "desired_tasks_num" {}
variable "ecr_repository_url" {
  
}
variable "sm_secret_id" {}

# service definition
variable "aws_alb_target_group" {
  
}

variable "ecs_sg" {}
# variable "aws_alb_listener" {
  
# }
variable "ecs_container_subnet" {
  
}

variable "aws_lb" {}


# variable "ecs_task_role" {
  
# }
# variable "ecs_task_execution_role"{}

variable "myRoot_domain_name" {}