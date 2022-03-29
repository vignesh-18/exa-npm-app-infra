# CODEBUILD_PROJECT
resource "aws_codebuild_project" "infra_repo_project" {
  name         = var.infra_build_project
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }

  # source_version = "dockerapp"

  environment {
    compute_type    = var.env_codebuild["compute"]
    image           = var.env_codebuild["image"]
    type            = var.env_codebuild["type"]
    privileged_mode = var.env_codebuild["privileged"]
    environment_variable {
      name  = "TF_COMMAND"
      value = "apply"
      type  = "PLAINTEXT"
    }
  }
}

# Artifact Bucket
resource "aws_s3_bucket" "codepipeline_bucket_infra" {
  bucket = "${var.prefix}-infra-artifact-bucket"
}

#App Deployment Pipeline
resource "aws_codepipeline" "infracodepipeline" {
  name     = "${var.prefix}-infra-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_infra.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "CheckoutInfra"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken           = jsondecode(data.aws_secretsmanager_secret_version.secret_text.secret_string)["oauth"]
        Owner                = var.github_infra["owner"]
        Repo                 = var.github_infra["repo"]
        Branch               = var.github_infra["branch"]
        PollForSourceChanges = var.github_infra["polling"]
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.infra_build_project #CodeBuild project name
      }
    }
  }
}
