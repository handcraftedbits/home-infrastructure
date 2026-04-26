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
