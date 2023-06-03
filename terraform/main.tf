# Create a aws provider with profile ray
provider "aws" {
  region = "eu-west-2"
  profile = "ray"
}

resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
}

# Create a fargate task
resource "aws_ecs_task_definition" "app-task" {
  family = "app-task"
  cpu = "256"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.app-task-execution-role.arn
  task_role_arn = aws_iam_role.app-task-role.arn

  container_definitions = file("container_definitions.json")
}

# role
resource "aws_iam_role" "app-task-execution-role" {
  name = "app-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "app-task-role" {
  name = "app-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# Run the task
resource "aws_ecs_service" "app-service" {
  name = "app-service"
  cluster = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  desired_count = 1
  launch_type = "FARGATE"
    network_configuration {
        subnets = ["subnet-0228ce7f8ec0c2db3"]
        security_groups = [aws_security_group.app-sg.id]
        assign_public_ip = true
    }

}

# Create security group to allow container running on fargate to access the internet which is in port 3000
resource "aws_security_group" "app-sg" {
  name = "app-sg"
  vpc_id = "vpc-025a6cafe43f03836"
#   Allow inbout traffic for any ip
    ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    # allow all connections
    cidr_blocks = ["0.0.0.0/0"]
    }
    

    egress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
    }
}

