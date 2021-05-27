variable "domain_user" {
  type        = string
}
variable "domain_password" {
  type        = string
}
variable "instance_name" {
  description = "The name of VM Instance"
  type        = string
  default     = "sles15sp1sap13"
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
variable "vm_image" {
  description = "Image to be used for Boot disk OS"
  type        = string
  default = "projects/pelagic-magpie-308310/global/images/sles15sp1sapnew"
}
