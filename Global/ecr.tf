resource "aws_ecr_repository" "repo" {
  name = var.ecr["ecr_repo"]
}

resource "aws_ecr_lifecycle_policy" "repo-policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep image deployed with tag latest",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["latest"],
        "countType": "imageCountMoreThan",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 2 any images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

# resource "null_resource" "pushs" {
#     provisioner "local-exec" {
#     command     = "${coalesce("./push.sh", "${path.module}/push.sh")} ${var.source_path} ${aws_ecr_repository.repo.repository_url} ${var.tag} ${data.aws_caller_identity.current.account_id}"
#     interpreter = ["PowerShell", "-Command"]
#   }
# }
