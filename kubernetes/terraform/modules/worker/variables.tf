variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "disk_image_id" {
  description = "Disk image for worker node"
}
variable "subnet_id" {
  description = "Subnets for modules"
}
variable "ssh_user" {
  description = "User for ssh connection"
}
variable "deploy_type" {
  description = "Prod/Stage"
}
variable "zone" {
  description = "Zone"
}
variable "number_of_workers" {
  description = "Number of workers"
}