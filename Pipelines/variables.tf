# -----------------------------------------------------------------------------
# Variables: CodePipeline
# -----------------------------------------------------------------------------
# variable "github_token" {
#   type        = string
#   description = "Github OAuth token"
# }

# variable "github_owner" {
#   type        = string
#   description = "Github username"
# }

# variable "github_repo" {
#   type        = string
#   description = "Github repository name"
# }

# variable "github_branch" {
#   type        = string
#   description = "Github branch name"
#   default     = "master"
# }

# variable "poll_source_changes" {
#   type        = string
#   default     = "false"
#   description = "Periodically check the location of your source content and run the pipeline if changes are detected"
# }

# Build Project Name
variable "build_project" {
  type    = string
  default = "dev-build-repo"
}