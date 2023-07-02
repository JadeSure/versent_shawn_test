locals {
  my_domain_name = var.myRoot_domain_name
}

provider "aws" {
  region = var.acm_region
  alias  = "ACM_Provider"
}

data "aws_route53_zone" "route53_zone" {
  name         = local.my_domain_name
  private_zone = false
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

# Referencing domain_validation_options With for_each Based Resources
resource "aws_route53_record" "route53_record" {
  for_each = {
    # when request a public certificate, aws certifiate manager will give us a CNAME => create a record set in route53
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}


# validate acm certificates (check one by one find correct one)
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  provider                = aws.ACM_Provider
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
}