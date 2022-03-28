# CODEBUILD
resource "aws_codebuild_project" "repo-project" {
  name         = var.build_project
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
  }
}

# Artifact Bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.prefix}-artifact-bucket"
}

#App Deployment Pipeline
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.prefix}-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "CheckoutApplication"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        OAuthToken           = "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"
        Owner                = var.github_app["owner"]
        Repo                 = var.github_app["repo"]
        Branch               = var.github_app["branch"]
        PollForSourceChanges = var.github_app["polling"]
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "BuildImage"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.build_project}"
      }
    }
  }
  #Deploys application latest changes deployed to ECS
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = "npmapp-cluster"
        ServiceName = "staging"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
