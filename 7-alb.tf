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
resource "aws_lb_target_group" "target-group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.test-vpc.id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}

# resource "aws_lb_target_group" "target-group" {
#   name     = "application-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.test-vpc.id
#   health_check {
#     enabled             = true
#     healthy_threshold   = 3
#     interval            = 10
#     matcher             = 200
#     path                = "/"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 3
#     unhealthy_threshold = 2
#   }
# }

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn # Referencing our tagrte group
  }
}

resource "aws_alb_listener" "alb_front_https" {
	load_balancer_arn	=	"${aws_lb.application_load_balancer.arn}"
	port			        =	"443"
	protocol		      =	"HTTPS"
	ssl_policy		    =	"ELBSecurityPolicy-2016-08"
	certificate_arn		=	"${aws_iam_server_certificate.aws_certificate.arn}"

	default_action {
		type			=	"redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
	}
}

# ALB target group attachment
resource "aws_lb_target_group_attachment" "ec2_attach" {
  count            = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}