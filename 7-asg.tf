# Create AWS Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name             = "${aws_launch_configuration.web.name}-asg"
  min_size         = 1
  desired_capacity = 1
  max_size         = 2
  # target_group_arns = ["${aws_lb_target_group.target-group.arn}"]

  # health_check_type = "LB"
  # load_balancers = [
  #   "${aws_lb.application_load_balancer.id}"
  # ]
  launch_configuration = aws_launch_configuration.web.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [
    "${aws_subnet.demosubnet.id}",
    "${aws_subnet.demosubnet1.id}"
  ]
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

# attach aws autoscaling group
resource "aws_autoscaling_attachment" "autoscaling-attach" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  lb_target_group_arn    = aws_lb_target_group.target-group.arn
}
