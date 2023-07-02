locals {
  my_domain_name = var.myRoot_domain_name
}

provider "aws" {
  region = var.acm_region
  alias  = "ACM_Provider"
}


resource "aws_acm_certificate" "acm_certificate" {
  provider    = aws.ACM_Provider
  domain_name = local.my_domain_name
  # query acm for the sub domain name 
  subject_alternative_names = ["*.${local.my_domain_name}"]
  validation_method         = "DNS"

  tags = {
    Environment = var.deploy_env
  }

  lifecycle {
    create_before_destroy = true
  }
}