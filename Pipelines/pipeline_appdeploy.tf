# CODEBUILD
resource "aws_codebuild_project" "repo-project" {
  name         = "${var.build_project}"
  service_role = "${aws_iam_role.codebuild-role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type     = "CODEPIPELINE"
  }

  source_version = "dockerapp"

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
}

# Artifact Bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "terraform-artifact-bucket-vignesh"
}

#App Deployment Pipeline
resource "aws_codepipeline" "codepipeline" {
  name     = "app-deploy-pipeline"
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
        Owner                = "vignesh-18"
        Repo                 = "exa-devops-assessment"
        Branch               = "dockerapp"
        PollForSourceChanges = "true"
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
#Deploys latest changes to ECS
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


