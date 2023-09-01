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
  count = var.prefix == "" ? 1 : 0

  length  = 6
  special = false
}

locals {
  basename = lower(var.prefix == "" ? "techxchange-simple-da-${random_string.random.0.result}" : var.prefix)
}

data "ibm_resource_group" "group" {
  name = var.username
}
