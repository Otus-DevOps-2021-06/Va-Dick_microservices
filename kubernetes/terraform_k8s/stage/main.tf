module "consul" {
  source = "../modules"
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

locals {
  service_account_key_file_json = jsondecode(file(var.service_account_key_file))
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "vpc" {
  source      = "../modules/vpc"
  zone        = var.zone
  deploy_type = var.deploy_type
}

module "cluster" {
  source                    = "../modules/cluster"
  zone                      = var.zone
  deploy_type               = var.deploy_type
  subnet_id                 = module.vpc.subnet_id
  network_id                = module.vpc.network_id
  service_account_id        = local.service_account_key_file_json.service_account_id
  node_service_account_id   = local.service_account_key_file_json.service_account_id
  depends_on = [
    module.vpc
  ]
}

module "node" {
  source                 = "../modules/node"
  zone                   = var.zone
  deploy_type            = var.deploy_type
  number_of_nodes        = var.number_of_nodes
  public_key_path        = var.public_key_path
  ssh_user               = var.ssh_user
  subnet_id              = module.vpc.subnet_id
  cluster_id             = module.cluster.cluster_id
  depends_on = [
    module.cluster
  ]
}