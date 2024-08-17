# ecs.tf
resource "aws_ecs_cluster" "pythonapp_cluster" {
  name = "pythonapp-cluster"
}

# ECS task definition to create the docker container for the Python app.
resource "aws_ecs_task_definition" "pythonapp_task" {
  family                   = "pythonapp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "pythonapp-app"
      image     = var.docker_image_endpoint
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        {
          name  = "DATABASE_HOST"
          value = aws_db_instance.pythonapp_db.address
        },
        {
          name  = "DATABASE_NAME"
          value = var.DATABASE_NAME
        },
        {
          name  = "DATABASE_USER"
          value = var.DATABASE_USER
        },
        {
          name  = "DATABASE_PASS"
          value = var.DATABASE_PASS
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "pythonapp_service" {
  name            = "pythonapp-service"
  cluster         = aws_ecs_cluster.pythonapp_cluster.id
  task_definition = aws_ecs_task_definition.pythonapp_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.subnet.*.id
    security_groups  = [aws_security_group.web_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pythonapp_tg.arn
    container_name   = "pythonapp-app"
    container_port   = 8000
  }

  depends_on = [aws_lb_target_group.pythonapp_tg]

}
