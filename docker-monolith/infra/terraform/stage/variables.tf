variable "service_account_key_file" {
  description = "key .json"
}

variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}

variable "deploy_type" {
  description = "Prod or Stage"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "reddit_app_disk_image" {
  description = "Disk image for reddit app"
}

variable "ssh_user" {
  description = "User for ssh connection"
}

variable "count_reddit_app" {
  description = "Number of virtual machines"
}
