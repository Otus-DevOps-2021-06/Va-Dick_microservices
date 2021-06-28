variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "reddit_app_disk_image" {
  description = "Disk image for reddit app"
}
variable "subnet_id" {
  description = "Subnets for modules"
}
variable "ssh_user" {
  description = "User for ssh connection"
}
variable "deploy_type" {
  description = "Prod or Stage"
}
variable "count_reddit_app" {
  description = "Number of virtual machines"
}