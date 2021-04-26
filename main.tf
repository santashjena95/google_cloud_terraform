module "vm_domain_joined" {
  source = "./modules"
  instance_name   = "sles12testv"
  vm_machine_type = "e2-small"
  vm_zone   = "us-east4-c"
  vm_hostname = "sles12testv.personallab.local"
  vm_image  = "projects/pelagic-magpie-308310/global/images/sles12vmimage"
}
