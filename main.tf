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

# creating security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id
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

# Creting aws instance
resource "aws_instance" "web" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  # key_name               = "ssh-test-key"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  subnet_id              = "${aws_subnet.public.id}"

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF
  
  tags = {
    Name = "demo-vm2"
  }
}

# Output of IP address of aws ec2 instance
output "ec2_global_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}




