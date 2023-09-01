variable "region" {
  type        = string
  default     = "us-south"
  description = "The region where to deploy the resources"
}

variable "tags" {
  type    = list(string)
  default = ["terraform", "techxchange-simple-da"]
}

provider "ibm" {
  region = var.region
}

variable "username" {
  type        = string
  description = "Your username"
}

resource "random_string" "random" {
  length  = 6
  special = false
}

locals {
  basename = lower("${var.username}-${random_string.random.result}")
}

data "ibm_resource_group" "group" {
  name = var.username
}
