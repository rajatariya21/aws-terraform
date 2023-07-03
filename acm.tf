# Find a certificate that is issued
data "aws_acm_certificate" "issued" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

# # Find a certificate issued by (not imported into) ACM
# data "aws_acm_certificate" "amazon_issued" {
#   domain      = "tf.example.com"
#   types       = ["AMAZON_ISSUED"]
#   most_recent = true
# }

# # Find a RSA 4096 bit certificate
# data "aws_acm_certificate" "rsa_4096" {
#   domain    = "tf.example.com"
#   key_types = ["RSA_4096"]
# }