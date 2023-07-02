# ACM in Sdyney
# module "local-acm" {
#   source             = "../../modules/acm"
#   myRoot_domain_name = var.myRoot_domain_name
#   deploy_env         = var.deploy_env
#   acm_region         = var.region
# }

module "back-route53" {
  source                  = "../../modules/route53"
  # acm_certificate         = module.local-acm.acm_certificate
  myRoot_domain_name      = var.myRoot_domain_name
  acm_region              = var.region
  # cloudfront_distribution = module.front-cdn.cloudfront_distribution
  deploy_env              = var.deploy_env
}


# Backend VPC
module "back-VPC" {
  source           = "../../modules/vpc"
  region           = var.region
  deploy_env       = var.deploy_env
  vpc_cidr_block   = var.vpc_cidr_block
  az_private_count = var.az_private_count
  az_public_count  = var.az_public_count
}


module "back-SG" {
  source         = "../../modules/sg"
  myapp_vpc      = module.back-VPC.myapp_vpc
  container_port = var.container_port
}

module "back-alb" {
  depends_on = [
    module.back-route53
  ]
  source                 = "../../modules/alb"
  alb_sg                 = module.back-SG.alb_sg
  myapp_public_subnet    = module.back-VPC.myapp_public_subnet
  myapp_vpc              = module.back-VPC.myapp_vpc
  acm_certificate_Sydney_arn = module.back-route53.acm_certificate_arn

  container_port    = var.container_port
  deploy_env        = var.deploy_env
  health_check_path = var.health_check_path
}


module "back-ecs" {
  depends_on = [
    module.back-alb,
  ]

  source             = "../../modules/ecs"
  deploy_env         = var.deploy_env
  container_cpu      = var.container_cpu
  container_memory   = var.container_memory
  ecr_repository_url = var.ecr_repository_url
  container_port     = var.container_port
  desired_tasks_num  = var.desired_tasks_num
  sm_secret_id = var.sm_secret_id

  aws_alb_target_group = module.back-alb.back_tg
  ecs_sg               = module.back-SG.ecs_sg

  ecs_container_subnet = var.az_private_count >= 1 ? module.back-VPC.myapp_private_subnet : module.back-VPC.myapp_public_subnet
  myRoot_domain_name   = var.myRoot_domain_name

  aws_lb = module.back-alb.aws_lb
}