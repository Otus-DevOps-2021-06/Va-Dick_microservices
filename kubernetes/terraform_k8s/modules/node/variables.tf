variable "zone" {
  description = "Zone"
}
variable "number_of_nodes" {
  description = "Number of workers"
}
variable "subnet_id" {
  description = "Subnets for modules"
}
variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}
variable "ssh_user" {
  description = "User for ssh connection"
}
variable "deploy_type" {
  description = "Prod/Stage"
}
variable "cluster_id" {
  description = "Cluster id"
}