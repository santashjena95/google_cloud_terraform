resource "google_compute_instance" "instance_creation" {
  name         = var.instance_name
  machine_type = var.vm_machine_type
  zone         = var.vm_zone
  hostname = var.vm_hostname
  scheduling {
  preemptible  = true
  automatic_restart = false
  }
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network = "test-vpc"
    subnetwork = "test-subnet"
    #network_ip = "10.0.0.24"
    access_config {
    
    }
  }
  metadata = {
    startup-script = <<SCRIPT
      #! /bin/bash
      sudo realm join --verbose PERSONALLAB.LOCAL
      sudo realm permit -g AccAdminSecOpsServers@PERSONALLAB.LOCAL
      sudo realm permit -g domain\ admins@PERSONALLAB.LOCAL
      sudo sh -c "echo 'entry_cache_timeout = 900' >> /etc/sssd/sssd.conf"
      sudo systemctl restart sssd.service
      SCRIPT
  }
}