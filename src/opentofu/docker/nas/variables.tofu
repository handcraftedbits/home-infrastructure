variable "keys" {
  description = <<-EOT
  keys = {
    makemkv : "The MakeMKV license key to use."
  }
  EOT

  type = object({
    makemkv = string
  })
}
