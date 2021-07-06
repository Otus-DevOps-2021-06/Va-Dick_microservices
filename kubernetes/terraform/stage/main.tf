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

module "master" {
  source                 = "../modules/master"
  zone                   = var.zone
  public_key_path        = var.public_key_path
  disk_image_id          = var.disk_image_id
  ssh_user               = var.ssh_user
  subnet_id              = module.vpc.subnet_id
  deploy_type            = var.deploy_type
  depends_on = [
    module.vpc
  ]
}

module "worker" {
  source                 = "../modules/worker"
  zone                   = var.zone
  number_of_workers      = var.number_of_workers
  public_key_path        = var.public_key_path
  disk_image_id          = var.disk_image_id
  ssh_user               = var.ssh_user
  subnet_id              = module.vpc.subnet_id
  deploy_type            = var.deploy_type
  depends_on = [
    module.vpc
  ]
}