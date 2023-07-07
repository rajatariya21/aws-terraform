Genetared SSH key in terraform using tls_private_key.
Create tls_private_key resource inside Terraform file.
Create aws_key_pair and store the public key onto AWS.
Private key - The private key will be generated and stored locally on your working computer.
Public key - Public key will be automatically uploaded to AWS.
For create private key and store in local machine. Using the local file resource to handle the pem file. 
# Store private key :  Generate and save private key(ec2-key.pem) in current directory
resource "local_file" "pem_file" {
  filename              = "./ec2-key.pem"
  file_permission       = "0400"
  directory_permission  = "0755"
  content               = <<-EOT
    ${tls_private_key.generated_private_key.private_key_pem}
  EOT
}
Create AWS EC2 instance using the generated tls_private_key.
Delete pem file or any other file during terraform destroy.
For this we add following provisioner into aws_key_pair resource.
# Delete pem file when run terraform destroy command
  provisioner "local-exec" {
    command = "rm -f ./ec2-key.pem"
    when    = destroy
    }
