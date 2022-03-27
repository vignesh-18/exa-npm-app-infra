terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}


/*
Setting AWS region to deploy Resources
Path and profile to refer credentials
*/

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:/Users/Vignesh.babu/.aws/credentials"]
  profile                  = "general_account_personal"
}
