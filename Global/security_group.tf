/*
creating a security group for application load balancer
*/
resource "aws_security_group" "lb" {
  name        = "${var.tag}-lb-sg"
  description = "controls access to the Application Load Balancer (ALB)"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*
creating a security group for ecs tasks
*/
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.prefix}-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
