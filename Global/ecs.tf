#ECS cluster
resource "aws_ecs_cluster" "npmcluster" {
  name = "${var.prefix}-cluster"
}

#renders a template from a template string
data "template_file" "apptemplate" {
  template = file("./npmapp.json.tpl")
  vars = {
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = var.ecr["image_tag"]
    container_name     = var.ecs["container_name"]
    log_group          = "${var.prefix}-log-group"
  }
}

#ECS task definition creation
resource "aws_ecs_task_definition" "task" {
  family                   = "npmapp"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 2048
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.apptemplate.rendered
  tags = {
    Application = "${var.tag}"
  }
}

#ECS service creation
resource "aws_ecs_service" "service" {
  name            = "${var.prefix}-service"
  cluster         = aws_ecs_cluster.npmcluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = ["${aws_subnet.private_subnets[0].id}", "${aws_subnet.private_subnets[1].id}"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = var.ecs["container_name"]
    container_port   = var.ecs["container_port"]
  }

  depends_on = [aws_lb_listener.http_forward, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = {
    Application = "${var.tag}"
  }
}

# cloud watch group for ECS
resource "aws_cloudwatch_log_group" "lg" {
  name = "${var.prefix}-log-group"

  tags = {
    Application = "${var.tag}"
  }
}
