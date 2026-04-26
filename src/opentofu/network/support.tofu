terraform {
  backend "s3" {
    bucket  = "hcb-terraform-state"
    encrypt = true
    key     = "network/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
    }
  }
}

provider "fortios" {
  hostname = "firewall.lan.howard.estate"
  insecure = true
  token    = var.keys.fortinet
}
