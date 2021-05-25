module "vm_domain_joined" {
  source = "./modules"
  instance_name   = "sles15sp1sap3"
  vm_machine_type = "e2-small"
  vm_zone   = "us-east4-c"
  vm_hostname = "sles15sp1sap3.personallab.local"
  vm_image  = "projects/pelagic-magpie-308310/global/images/sles15sp1sap2"
}
