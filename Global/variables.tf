variable "prefix" {
  description = "prefix prepended to names of all resources created"
  default     = "terraform-npmapp"
}

variable "region" {
  description = "selects the aws region to apply these services to"
  default     = "us-east-1"
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

#VPC Details
variable "cidr" {
  type    = string
  default = "10.16.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
  ]
}

variable "public_subnets_ip" {
  type = list(string)
  default = [
    "10.16.0.0/24",
    "10.16.1.0/24"
  ]
}

variable "private_subnets_ip" {
  type = list(string)
  default = [
    "10.16.2.0/24",
    "10.16.3.0/24"
  ]
}
