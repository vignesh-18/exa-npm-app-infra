# Retrieving oauth from secrets manager and used in pipeline for code checkout
data "aws_secretsmanager_secret_version" "secret_text" {
  secret_id = var.github_token
}
