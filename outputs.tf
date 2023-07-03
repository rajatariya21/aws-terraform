output "this_acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.acm_certificate.arn
}
