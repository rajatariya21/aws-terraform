# Create Loadbalancer
resource "aws_alb" "default" {
  name                       = "ecs-lb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  idle_timeout               = 3600

  # subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.sg_lb.id]
  subnets = [ # Referencing the default subnets
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
}

# Create target group for lb
resource "aws_lb_target_group" "tg_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id # Referencing the default VPC

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
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_group.arn # Referencing our tagrte group
  }
}

# Add the load balancer security group resource 
resource "aws_security_group" "sg_lb" {
  name   = "alb-security-group"
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}