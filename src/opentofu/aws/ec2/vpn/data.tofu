data "aws_ami" "nixos" {
  most_recent = true
  owners = ["427812963091"]

  filter {
    name = "architecture"
    values = ["arm64"]
  }
  filter {
    name = "name"
    values = ["nixos/25.11*"]
  }
}
