provider "aws" {
  region = "us-east-1"

}

resource "aws_acm_certificate" "acm_certificate" {

  domain_name = var.domain_name


  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  validation_method = "EMAIL"

  tags = {
    Name = var.domain_name
  }
}