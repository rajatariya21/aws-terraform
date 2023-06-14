resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = var.domain_name
  subject_alternative_names = [var.alternative_name]
  validation_method = "DNS"
}

# validate acm certificate
resource "aws_acm_certificate_validation" "validation_cert" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
}

