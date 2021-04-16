resource "google_compute_instance" "instance_create" {
  name         = "sles12testing"
  machine_type = "e2-small"
  zone         = "us-east4-c"
  hostname = "sles12testing.personallab.local"
  scheduling {
  preemptible  = true
  automatic_restart = false
  }
  boot_disk {
    initialize_params {
      image = "projects/pelagic-magpie-308310/global/images/image-sles12"
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
    shutdown-script = <<SCRIPT
      #! /bin/bash
      sudo realm leave --verbose PERSONALLAB.LOCAL
      SCRIPT
  }
}
