#----------------------------------------------
# Role assumed by infra deploy code build role
#----------------------------------------------

resource "aws_iam_role" "assume_role" {
  name = "${var.prefix}-assume-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "${aws_iam_role.codebuild_role.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#Attaches an IAM role inline policy
resource "aws_iam_role_policy" "assumerole_policy" {
  name = "${var.prefix}-assumerole-policy"
  role = aws_iam_role.assume_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*",
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

#storing assume role arn to parameter store
resource "aws_ssm_parameter" "assume_role" {
  name  = "assumerole"
  type  = "String"
  value = aws_iam_role.assume_role.arn
}