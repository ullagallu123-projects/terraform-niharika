variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "public_subnet_cidr" {
  type    = list(string)
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["192.168.3.0/24", "192.168.4.0/24"]
}

variable "db_subnet_cidr" {
  type    = list(string)
  default = ["192.168.5.0/24", "192.168.6.0/24"]
}
variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}


variable "environment" {
  type    = string
  default = "test"
}
variable "project_name" {
  type    = string
  default = "ecs"
}
variable "common_tags" {
  type = map(any)
  default = {
    "Owner"        = "siva"
    "Terraform"    = true
    "Project_Name" = "ecs"
    "Environemt"   = "test"
  }
}
variable "enable_nat" {
  type    = bool
  default = true
}
variable "vpc_peering_enable" {
  type = bool
  default = true
}