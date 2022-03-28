resource "aws_lb" "alb" {
  name               = "alb-npmapp"
  subnets            = data.aws_subnet_ids.defaultsubnet.ids
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  tags = {
    Application = "npmapp"
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name        = "npmapp-alb-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.defaultvpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "90"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "20"
    path                = "/health"
    unhealthy_threshold = "2"
  }
}
