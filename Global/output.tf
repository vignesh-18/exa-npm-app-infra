# Load balancer DNS will be displayed in the console
output "app_dns" {
  value = aws_lb.alb.dns_name
}
