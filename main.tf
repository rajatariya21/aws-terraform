# Generate ssh key on aws
resource "tls_private_key" "generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {

  # Name of key : Write the custom name of your key
  key_name   = "ec2-key"

  # Public Key: The public will be generated using the reference of tls_private_key.generated_private_key
  public_key = tls_private_key.generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(ec2-key.pem) in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.generated_private_key.private_key_pem}' > ec2-key.pem
      chmod 400 ec2-key.pem
    EOT
  }
}

# creating security group
resource "aws_security_group" "allow_ports" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.default.id
  dynamic "ingress" {
    for_each = [22, 80, 81, 8080, 443]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-SG"
  }
}

# locals {
#   subs = concat([aws_subnet.public.*.id], [aws_subnet.private.*.id])
# }

# Creting aws instance
resource "aws_instance" "web" {
  count         = 3
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name
  # key_name               = "ssh-test-key"
  vpc_security_group_ids = ["${aws_security_group.allow_ports.id}"]
  # subnet_id              = ["${element(local.subs, count.index)}"]
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  associate_public_ip_address = true
  tags = {
    Name = "demo-vm-${count.index}"
  }
}







