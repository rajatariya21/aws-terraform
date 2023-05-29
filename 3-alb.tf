# Create Application load balancer
resource "aws_lb" "application_load_balancer" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demosg-alb.id]
  subnets            = [aws_subnet.demosubnet.id, aws_subnet.demosubnet1.id]

  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}

# Create target group and listener
# resource "aws_lb_target_group" "target-group" {
#   name        = "target-group"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = aws_vpc.demovpc.id # Referencing the default VPC
#   health_check {
#     matcher = "200,301,302"
#     path    = "/"
#   }
# }

resource "aws_lb_target_group" "target-group" {
  name     = "application-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demovpc.id
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

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn # Referencing our tagrte group
  }
}

# # ALB target group attachment
# resource "aws_lb_target_group_attachment" "ec2_attach" {
#   count            = length(aws_launch_configuration.web)
#   target_group_arn = aws_lb_target_group.target-group.arn
#   target_id        = aws_launch_configuration.web[count.index].id
#   port             = 80
# }

