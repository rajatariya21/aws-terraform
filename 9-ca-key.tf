# resource "tls_private_key" "atariya_ca_private_key" {
#   algorithm = "RSA"
# }
# #
# resource "local_file" "atariya_ca_key" {
#   content  = tls_private_key.atariya_ca_private_key.private_key_pem
#   filename = "${path.module}/certs/atariyaCA.key"
# }

# resource "tls_self_signed_cert" "atariya_ca_cert" {
#   private_key_pem = tls_private_key.atariya_ca_private_key.private_key_pem

#   is_ca_certificate = true

#   subject {
#     country             = "IN"
#     province            = "Mahrashatra"
#     locality            = "NGP"
#     common_name         = "application-lb-1750112744.us-east-1.elb.amazonaws.com"
#     organization        = "Net Solution."
#     organizational_unit = "IT"
#   }

#   validity_period_hours = 43800 //  1825 days or 5 years

#   allowed_uses = [
#     "digital_signature",
#     "cert_signing",
#     "crl_signing",
#   ]
# }

# resource "local_file" "atariya_ca_cert" {
#   content  = tls_self_signed_cert.atariya_ca_cert.cert_pem
#   filename = "${path.module}/certs/atariyaCA.crt"
# }




# # Create private key for server certificate 
# resource "tls_private_key" "atariya_internal" {
#   algorithm = "RSA"
# }

# resource "local_file" "atariya_internal_key" {
#   content  = tls_private_key.atariya_internal.private_key_pem
#   filename = "${path.module}/certs/dev.atariya.key"
# }

# # Create CSR for for server certificate 
# resource "tls_cert_request" "atariya_internal_csr" {

#   private_key_pem = tls_private_key.atariya_internal.private_key_pem

#   dns_names = ["dev.atariya.internal"]

#   subject {
#     country             = "IN"
#     province            = "Mahrashatra"
#     locality            = "NGP"
#     common_name         = "Cloud Manthan Internal Development "
#     organization        = "Cloud Manthan"
#     organizational_unit = "Development"
#   }
# }

# # Sign Seerver Certificate by Private CA 
# resource "tls_locally_signed_cert" "atariya_internal" {
#   // CSR by the development servers
#   cert_request_pem = tls_cert_request.atariya_internal_csr.cert_request_pem
#   // CA Private key 
#   ca_private_key_pem = tls_private_key.atariya_ca_private_key.private_key_pem
#   // CA certificate
#   ca_cert_pem = tls_self_signed_cert.atariya_ca_cert.cert_pem

#   validity_period_hours = 43800

#   allowed_uses = [
#     "digital_signature",
#     "key_encipherment",
#     "server_auth",
#     "client_auth",
#   ]
# }

# resource "local_file" "atariya_internal_cert" {
#   content  = tls_locally_signed_cert.atariya_internal.cert_pem
#   filename = "${path.module}/certs/dev.atariya.crt"
# }





