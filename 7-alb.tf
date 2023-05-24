# Cretae a load balancer
# resource "aws_alb" "application_load_balancer" {
#   name               = "test-lb-tf" # Naming our load balancer
#   load_balancer_type = "application"
#   subnets = [ # Referencing the subnets
#     "${aws_subnet.public.id}"
#   ]
#   # Referencing the security group
#   security_groups = ["${aws_security_group.allow_tls.id}"]
# }


resource "aws_lb" "application_load_balancer" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

# Create target group and listener
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.test-vpc.id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our tagrte group
  }
}