# Creting aws instance
resource "aws_instance" "web" {
  count         = 1
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  # subnet_id              = aws_subnet.public.*.id
  subnet_id = element(aws_subnet.public.*.id, count.index)

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "demo-vm2"
  }
}