# State file stored using backend(S3) from code pipeline.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-exa-statefile-pipeline"
    key            = "pipeline_statefile"
    region         = "us-east-1"
    profile        = "general_account_personal"
    dynamodb_table = "tf-state-lock-dynamo-pipeline"
  }
}

# Setting AWS region to deploy Resources and profile to refer credentials
provider "aws" {
  region  = "us-east-1"
  profile = "general_account_personal"
}
