# resource "aws_acm_certificate" "tch-cert" {
#   private_key=file("./certs/atariyaCA.key")
#   certificate_body = file("./certs/atariyaCA.crt")
# #   certificate_chain=file("server.csr")
#   }

resource "aws_iam_server_certificate" "aws_certificate" {
  name             = "atariyaCA"
  certificate_body = "${file("./certs/atariyaCA.crt")}"
  private_key      = "${file("./certs/atariyaCA.key")}"

}



# resource "aws_acm_certificate" "cert" {
#   private_key      = tls_private_key.example.private_key_pem
#   certificate_body = tls_self_signed_cert.example.cert_pem
# }