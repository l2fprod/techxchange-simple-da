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

resource "ibm_resource_instance" "cos" {
  name              = "${local.basename}-cos"
  resource_group_id = data.ibm_resource_group.group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  tags              = var.tags
}

resource "ibm_cos_bucket" "bucket" {
  bucket_name          = "${local.basename}-bucket"
  resource_instance_id = ibm_resource_instance.cos.id
  region_location      = var.region
  storage_class        = "smart"
}

output "cos_bucket_name" {
  value = ibm_cos_bucket.bucket.bucket_name
}
