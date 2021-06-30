output "external_ip_addresses_app" {
  description = "External addresses of virtual machines \"Reddit\""
  value = toset([
    for app in yandex_compute_instance.app : app.network_interface.0.nat_ip_address
  ])
}
