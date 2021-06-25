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

module "app" {
  source                 = "../modules/reddit"
  subnet_id              = module.vpc.subnet_id
  deploy_type            = var.deploy_type
  reddit_app_disk_image  = var.reddit_app_disk_image
  ssh_user               = var.ssh_user
  public_key_path        = var.public_key_path
  count_reddit_app       = var.count_reddit_app
  depends_on = [
    module.vpc
  ]
}