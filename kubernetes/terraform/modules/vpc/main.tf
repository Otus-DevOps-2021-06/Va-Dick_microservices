terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "network" {
  name = "kubernetes-network-${var.deploy_type}"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "kubernetes-subnet-${var.deploy_type}"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}