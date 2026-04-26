variable "keys" {
  description = <<-EOT
  keys = {
    fortinet : "The key used to access Fortinet device APIs."
  }
  EOT

  type = object({
    fortinet = string
  })
}
