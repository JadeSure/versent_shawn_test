aws_profile = "versent"
region      = "ap-southeast-2"

deploy_env = "uat"

myRoot_domain_name = "shawnwang.site"


# VPC
vpc_cidr_block   = "10.0.0.0/16"
az_private_count = 0
az_public_count  = 2

# alb
health_check_path = "/health_check"

# ecs
desired_tasks_num  = 2
container_port     = 8080
container_cpu      = 256
container_memory   = 512
ecr_repository_url = "046381260578.dkr.ecr.ap-southeast-2.amazonaws.com/versent_test_uat"
sm_secret_id = "versent-secret-uat"