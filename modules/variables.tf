variable "instance_name" {
  description = "The name of VM Instance"
  type        = string
}
variable "vm_machine_type" {
  description = "Machine type of VM Instance"
  type        = string
  default     = "e2-small"
}
variable "vm_zone" {
  description = "Zone location of VM Instance"
  type        = string
  default     = "us-east4-c"
}
variable "vm_hostname" {
  description = "Hostname of VM Instance"
  type        = string
}
variable "vm_image" {
  description = "Image to be used for Boot disk OS"
  type        = string
}