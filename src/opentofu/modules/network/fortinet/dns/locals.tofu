locals {
  cname_records_flattened = flatten([
    for target, cnames in var.aliases : [
      for cname in cnames : {
        hostname       = cname
        canonical_name = target
      }
    ]
  ])

  dns_entries = {
    for entry in concat(
      [for hostname, ip in var.hostnames : {
        hostname       = hostname
        type           = "A"
        ip             = ip
        canonical_name = null
      }],
      [for record in local.cname_records_flattened : {
        hostname       = record.hostname
        type           = "CNAME"
        ip             = null
        canonical_name = record.canonical_name
      }]
    ) : entry.hostname => entry
  }
}
