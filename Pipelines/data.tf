# Retrieving oauth from secrets manager
data "aws_secretsmanager_secret_version" "secret_text" {
  secret_id = var.github_token
}
