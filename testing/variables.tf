variable "azs" {
    default = ["ap-south-1a", "ap-south-1b"]
}
variable "public_subnet_cidr" {
  default =   ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnet_cidr" {
    default =   ["192.168.3.0/24", "192.168.4.0/24"]
}

variable "db_subnet_cidr" {
    default = ["192.168.5.0/24", "192.168.6.0/24"]
}
variable "vpc_cidr" {
   default =  "192.168.0.0/16"
}


variable "environment" {
    default = "bapatla"
}
variable "project_name" {
 default = "mini"
}
variable "common_tags" {
    default = {
    "Owner"        = "siva"
    "Terraform"    = true
    "Project_Name" = "mini"
    "Environemt"   = "bapatla"
  }
}
variable "enable_nat" {
    default = false
}
variable "vpc_peering_enable" {
    default = true
}