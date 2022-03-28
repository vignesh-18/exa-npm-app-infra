variable "prefix" {
    description = "prefix prepended to names of all resources created"
    default = "terraform-npmapp"
}

variable "port" {
    description = "port the container exposes, that the load balancer should forward port 80 to"
    default = "3000"
}

variable "region" {
    description = "selects the aws region to apply these services to"
    default = "us-east-1"
}

variable "tag" {
  description = "tag to use for our new docker image"
  default     = "latest"
}