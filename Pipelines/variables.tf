variable "prefix" {
  description = "prefix prepended to names of all resources created"
  default     = "terraform-npmapp"
}

variable "build_project" {
  description = "build project name"
  default     = "npmapp-build-project"
}

variable "github_app" {
  description = "application code checkout details"
  type        = map(any)
  default = {
    "owner"   = "vignesh-18"
    "repo"    = "exa-devops-assessment"
    "branch"  = "dockerapp"
    "polling" = true
  }
}

variable "env_codebuild" {
  description = "environment details for code build project"
  type        = map(any)
  default = {
    "compute"    = "BUILD_GENERAL1_SMALL"
    "image"      = "aws/codebuild/standard:5.0"
    "type"       = "LINUX_CONTAINER"
    "privileged" = true
  }
}
