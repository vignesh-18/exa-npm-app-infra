/*
State file stored using backend(S3) from code pipeline.
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
  backend "s3" {
    bucket                  = "terraform-exa-statefile-global"
    key                     = "backend_statefile"
    region                  = "us-east-1"
    # profile                 = "general_account_personal"
    # shared_credentials_file = "C:/Users/Vignesh.babu/.aws/credentials"
    dynamodb_table          = "tf-state-lock-dynamo-global"
  }
}

/*
Setting AWS region to deploy Resources and
Path and profile to refer credentials
*/
provider "aws" {
  region                   = "us-east-1"
  # shared_credentials_files = ["C:/Users/Vignesh.babu/.aws/credentials"]
  # profile                  = "general_account_personal"
}
