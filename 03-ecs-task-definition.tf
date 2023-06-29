
resource "aws_cloudwatch_log_group" "log_group" {
  name = "awslogs"


}

# Create ecs task definition
resource "aws_ecs_task_definition" "my_first_task" {
  family = "my-first-task" # Naming our first task
  container_definitions = jsonencode([
    {
      name      = "my-first-task",
      image     = "932919696617.dkr.ecr.us-east-1.amazonaws.com/app-repo:latest",
      cpu       = 256
      memory    = 512
      essential = true
      logConfiguration = {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.log_group.id,
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}
