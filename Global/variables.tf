variable "prefix" {
  description = "prefix prepended to names of all resources created"
  default     = "terraform-npmapp"
}

variable "container_port" {
  description = "port the container exposes, that the load balancer should forward port 80 to"
  default     = "3000"
}

variable "region" {
  description = "selects the aws region to apply these services to"
  default     = "us-east-1"
}

variable "image_tag" {
  description = "tag to use for our new docker image"
  default     = "latest"
}

variable "repo" {
  description = "repo name to push images"
  default     = "exa/npmapp"
}

variable "container" {
  description = "container name"
  default     = "terraform-npmapp-container"
}

variable "tag" {
  description = "tag to use for resources"
  default     = "npmapp"
}

variable "ecs" {
  description = "container details like port container exposed to and container name"
  type        = map(any)
  default = {
    "container_name" = "terraform-npmapp-container"
    "container_port" = "3000"
  }
}

variable "ecr" {
  description = "repository details like repo from where image is pushed and pulled, tag used for docker image"
  type        = map(any)
  default = {
    "ecr_repo"  = "exa/npmapp"
    "image_tag" = "latest"
  }
}