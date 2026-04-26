locals {
  sorted_reservations = values(tomap({
    for reservation in var.reservations :
    join(".", [for octet in split(".", reservation.ip_address) : format("%03d", tonumber(octet))]) => reservation
  }))
}
