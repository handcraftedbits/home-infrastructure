module "vpn" {
  source = "../../../modules/aws/ec2"

  additional_ingress_rules = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow inbound Wireguard connections"
      from_port   = 51820
      protocol    = "udp"
      to_port     = 51820
    }
  ]
  ami           = data.aws_ami.nixos.id
  flake_host    = "vpn"
  hosted_zone   = "curtisshoward.com"
  hostname      = "vpn.curtisshoward.com"
  instance_type = "t4g.nano"
  nix           = var.nix
  tags = {
    project : "vpn"
  }
}

