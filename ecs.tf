data "template_file" "apptemplate" {
  template = file("./npmapp.json.tpl")
  vars = {
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = "latest"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "npmapp-containerised"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.apptemplate.rendered
  tags = {
    Application = "npmapp"
  }
}

resource "aws_ecs_service" "service" {
  name            = "staging"
  cluster         = aws_ecs_cluster.staging.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnet_ids.defaultsubnet.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "npmapp"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = {
    Application = "npmapp"
  }
}


resource "aws_cloudwatch_log_group" "lg" {
  name = "aws-terraform-log-group"

  tags = {
    Application = "npmapp"
  }
}

resource "aws_ecs_cluster" "staging" {
  name = "npmapp-cluster"
}