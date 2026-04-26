terraform {
  backend "s3" {
    bucket  = "hcb-terraform-state"
    encrypt = true
    key     = "docker/nas/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "ssh://truenas_admin@nas.lan.howard.estate"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null"
  ]
}
