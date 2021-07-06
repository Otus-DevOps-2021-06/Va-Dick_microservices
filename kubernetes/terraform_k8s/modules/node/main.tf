terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_kubernetes_node_group" "node_group" {
  cluster_id  = var.cluster_id
  name        = "node-group-${var.deploy_type}"
  description = "node-group"
  version     = "1.19"

  instance_template {
    platform_id = "standard-v2"
    metadata = {
      ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
    }

    network_interface {
      nat                = true
      subnet_ids         = [var.subnet_id]
    }

    resources {
      memory = 8
      cores  = 4
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = var.number_of_nodes
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}
