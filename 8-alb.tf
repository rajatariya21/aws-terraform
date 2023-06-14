# target group
# resource "aws_lb_target_group" "target-group" {
#   health_check {
#     interval            = 10
#     path                = "/"
#     protocol            = "HTTP"
#     timeout             = 5
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#   }

#   name        = "demo-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.test-vpc.id
# }

resource "aws_lb_target_group" "target-group" {
  name     = "application-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test-vpc.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

# Create Listner
# resource "aws_lb_listener" "listener" {
#   load_balancer_arn = aws_lb.application_load_balancer.arn # Referencing our load balancer
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target-group.arn # Referencing our tagrte group
#   }
# }

# create a listener on port 443 with forward action
# terraform aws create listener
resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.application_load_balancer.arn # Referencing our load balancer
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = aws_acm_certificate.acm_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn # Referencing our tagrte group
  }
}


# create a listener on port 80 with redirect action
# terraform aws create listener
resource "aws_lb_listener" "http-to-https" {
  load_balancer_arn = aws_lb.application_load_balancer.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Creating ALB
resource "aws_lb" "application_load_balancer" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

# ALB target group attachment
resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}