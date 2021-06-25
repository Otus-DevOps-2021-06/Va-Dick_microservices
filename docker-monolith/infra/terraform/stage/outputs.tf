output "external_ip_address_app" {
    description = "External addresses of virtual machines \"Reddit\""
    value = module.app.external_ip_addresses_app
}