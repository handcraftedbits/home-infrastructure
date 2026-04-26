terraform {
  backend "s3" {
    bucket  = "hcb-terraform-state"
    encrypt = true
    key     = "vm/dbhost/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    vsphere = {
      source = "vmware/vsphere"
    }
  }
}

provider "vsphere" {
  allow_unverified_ssl = true
  password             = var.esxi.password
  user                 = var.esxi.username
  vsphere_server       = var.esxi.hostname
}
