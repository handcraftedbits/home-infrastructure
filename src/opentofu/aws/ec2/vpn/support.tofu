terraform {
  backend "s3" {
    bucket  = "hcb-terraform-state"
    encrypt = true
    key     = "aws/ec2/vpn/terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}
