terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_compute_instance" "worker" {
  count = var.number_of_workers
  zone  = var.zone
  name = "kubernetes-worker-${var.deploy_type}-${count.index}"
  labels = {
    tags = "kubernetes-worker-${var.deploy_type}"
  }

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id  = var.disk_image_id
      size      = 40
      type      = "network-hdd"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }
}