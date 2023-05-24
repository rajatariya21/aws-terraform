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