# Cretae an ecs service
resource "aws_ecs_service" "my_first_service" {
  name            = "my-first-service"                        # Naming our first service
  cluster         = aws_ecs_cluster.ecs_cluster.id            # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.my_first_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 2 # Setting the number of containers we want deployed to 2

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_group.arn # Referencing our target group
    container_name   = "my-first-task"
    container_port   = 80 # Specifying the container port
  }

  network_configuration {
    # subnets          = aws_subnet.public.*.id
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups = [aws_security_group.sg_lb.id, aws_security_group.service_security_group.id]
  }
}

resource "aws_security_group" "service_security_group" {
  name   = "ecs-security-group"
  vpc_id = aws_default_vpc.default_vpc.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.sg_lb.id}"]
  }

  egress {
    from_port   = 0             # Allowing any incoming port
    to_port     = 0             # Allowing any outgoing port
    protocol    = "-1"          # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}