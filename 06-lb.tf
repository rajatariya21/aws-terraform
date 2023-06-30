# Create Loadbalancer
resource "aws_alb" "default" {
  name                       = "ecs-lb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  idle_timeout               = 3600

  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.sg_lb.id]
  # subnets = [ # Referencing the default subnets
  #   "${aws_default_subnet.default_subnet_a.id}",
  #   "${aws_default_subnet.default_subnet_b.id}",
  #   "${aws_default_subnet.default_subnet_c.id}"
  # ]
}

# Create target group for lb
resource "aws_lb_target_group" "tg_group" {
  name        = "target-group"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.default.id # Referencing the default VPC

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    path                = "/"
    port                = "80"
  }
}

# Create listner for lb
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_alb.default.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "redirect"
    # target_group_arn = aws_lb_target_group.tg_group.arn # Referencing our tagrte group
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb_listner_https" {
  load_balancer_arn = aws_alb.default.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:932919696617:certificate/5334bc20-dc8c-49d4-9b44-f04903caca42"    # Need to create ssl certificate into AWS ACM

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_group.arn
  }
}

# Add the load balancer security group resource 
resource "aws_security_group" "sg_lb" {
  name   = "alb-security-group"
  vpc_id = aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}