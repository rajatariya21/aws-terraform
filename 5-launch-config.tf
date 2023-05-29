# Create AWS Launch configuration
resource "aws_launch_configuration" "web" {
  name_prefix = "web-"
  # image_id                    = "ami-087c17d1fe0178315" 
  image_id                    = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.generated_key.key_name
  security_groups             = ["${aws_security_group.demosg-ec2.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("install-apache.sh")}"
  # user_data = <<-EOF
  # #! /bin/bash
  # sudo apt-get update -y
  # sudo apt-get install ca-certificates curl gnupg -y
  # sudo install -m 0755 -d /etc/apt/keyrings
  # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  # sudo chmod a+r /etc/apt/keyrings/docker.gpg
  # echo \
  # "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  # "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  # sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # sudo apt-get update -y
  # sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  # sudo usermod -a -G docker $USER
  # sudo chkconfig docker on
  # sudo chmod 666 /var/run/docker.sock
  # docker run -d -p 80:80 --name my-web rajdocker85/workshop
  # EOF

  lifecycle {
    create_before_destroy = true
  }
}