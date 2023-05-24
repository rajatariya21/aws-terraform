# Create ssh key on aws
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
}
resource "aws_key_pair" "generated_key" {
  key_name   = "demo-ssh-key"
  public_key = tls_private_key.ssh-key.public_key_openssh
  depends_on = [
    tls_private_key.ssh-key
  ]
}
resource "local_file" "key" {
  content         = tls_private_key.ssh-key.private_key_pem
  filename        = "demo-ssh-key.pem"
  file_permission = "0400"
  depends_on = [
    tls_private_key.ssh-key
  ]
}