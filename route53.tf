resource "aws_route53_record" "rstudio" {
  zone_id = "Z00030683DIEXQML9BNHK"
  name    = "pr-rstudio.org"
  type    = "A"
  alias {
    name                   = aws_lb.rstudio_alb.dns_name
    zone_id                = aws_lb.rstudio_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "rstudio_cert" {
  domain_name       = "pr-rstudio.org"
  validation_method = "DNS"
}
