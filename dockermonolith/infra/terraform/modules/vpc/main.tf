terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_vpc_network" "app-network" {
  name = "app-network-${var.deploy_type}"
}

resource "yandex_vpc_subnet" "app-subnet" {
  name           = "app-subnet-${var.deploy_type}"
  zone           = var.zone
  network_id     = yandex_vpc_network.app-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
