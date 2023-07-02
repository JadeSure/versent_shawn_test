data "aws_route53_zone" "route53_zone" {
  name         = var.myRoot_domain_name
  private_zone = false
}

resource "aws_route53_record" "api_domain" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "${var.deploy_env}-versent-api.${var.myRoot_domain_name}"

  type = "A"

  alias {
    name                   = var.aws_lb.dns_name
    zone_id                = var.aws_lb.zone_id
    evaluate_target_health = false
  }

  depends_on = [var.aws_lb]
}