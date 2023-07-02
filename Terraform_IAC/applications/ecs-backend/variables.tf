# Base
variable "aws_profile" {
  description = "aws user account access and secret key holder"
  type        = string
  default     = "default"
}
variable "region" {
  description = "AWS server region"
  type        = string
  default     = "ap-southeast-2"
}

variable "myRoot_domain_name" {
  description = "root domain name"
  type        = string
}
# variable "acm_region" {
#   description = "Certificate region, must be in Virginia"
#   type        = string
#   default     = "us-east-1"
# }
variable "deploy_env" {
  description = "deploy env to distinguish uat or prod"
  type        = string
}

# Back VPC
variable "vpc_cidr_block" {
  description = "AWS VPC vpc_cidr_block"
  type        = string
}

variable "az_private_count" {
  description = "split to how many private subnets"
  type        = number
}
variable "az_public_count" {
  description = "split to how many public subnets"
  type        = number
}

# ECS
variable "health_check_path" {
  description = "ecs health check path"
  type        = string
}

variable "desired_tasks_num" {
  description = "ecs service to create the number of tasks"
  type        = number
}

variable "container_port" {
  description = "ecs container port"
  type        = number
}

variable "container_cpu" {
  description = "ecs container cpu size"
  type        = number
}

variable "container_memory" {
  description = "ecs container memory size"
  type        = number
}

variable "ecr_repository_url" {
  description = "ecs container source from ecr"
  type        = string
}

variable "sm_secret_id" {
  description = "set secret password saved in secret manager"
  type = string
}