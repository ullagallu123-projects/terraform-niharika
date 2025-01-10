terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
  backend "s3" {
    bucket = "hello-backend-niharika"
    key    = "vpc/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "vpc-backend-locking"
  }
}

provider "aws" {
  region  = "ap-south-1"
}