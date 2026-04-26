variable "additional_ingress_rules" {
  default = []
  description = <<-EOT
  additional_ingress_rules = {
    cidr_blocks : "The CIDR block(s) where the ingress rule will apply."
    description : "A desription of the ingress rule."
    from_port   : "The starting port for the ingress rule."
    protocol    : "The protocol for the ingress rule ('tcp' or 'udp')."
    to_port     : "The endpoint port for the ingress rule."
  }
  EOT
  type = list(object({
    cidr_blocks = list(string)
    description = optional(string)
    from_port = number
    protocol  = string
    to_port   = number
  }))
}

variable "ami" {
  description = "The AMI to use."
  type        = string
}

variable "disk_space" {
  default     = 50
  description = "The amount of disk space to allocate, in GB."
  type        = number

  validation {
    condition     = var.disk_space == floor(var.disk_space) && var.disk_space > 0
    error_message = "The disk space amount must be an integer greater than 0."
  }
}

variable "flake_host" {
  description = "The name of the flake's NixOS configuration to use."

  type = string
}

variable "hosted_zone" {
  description = "The hosted zone to use."

  type = string
}

variable "hostname" {
  description = "The hostname for the ECS instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use."
  type        = string
}

variable "nix" {
  description = <<-EOT
  nix = {
    anonymous_flake_url : "The URL of the Nix flake to use which can be accessed anonymously."
    flake_path          : "The relative path under /opt/config where flake.nix is located."
    flake_url           : "The URL of the Nix flake to use."
  }
  EOT

  type = object({
    anonymous_flake_url = string
    flake_path          = string
    flake_url           = string
  })
}

variable "tags" {
  description = "Tags to apply to the created resources."
  default = {}
  type = map(string)
}
