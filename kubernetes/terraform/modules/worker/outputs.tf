output "external_worker_ip_address" {
  value = toset([
    for worker in yandex_compute_instance.worker : worker.network_interface.0.nat_ip_address
  ])
}