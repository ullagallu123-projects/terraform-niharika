module "testing" {
  source = "../vpc"
  vpc_cidr="192.168.0.0/16"
  azs = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidr=["192.168.1.0/24", "192.168.2.0/24"]
  private_subnet_cidr=["192.168.3.0/24", "192.168.4.0/24"]
  db_subnet_cidr=["192.168.5.0/24", "192.168.6.0/24"]
  environment="bapatla"
  project_name = "niharika"
  common_tags={
    "Owner"        = "siva"
    "Terraform"    = true
    "Project_Name" = "niharika"
    "Environemt"   = "bapatla"
  }
  enable_nat=false
  vpc_peering_enable=true
}