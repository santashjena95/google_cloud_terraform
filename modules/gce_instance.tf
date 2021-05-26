resource "google_compute_instance" "instance_creation" {
  name         = var.instance_name
  machine_type = var.vm_machine_type
  zone         = var.vm_zone
  labels = { appname="test-terraform",environment="nonprod" }
  scheduling {
  preemptible  = true
  automatic_restart = false
  }
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "terraform@pelagic-magpie-308310.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  network_interface {
    network = "test-vpc"
    subnetwork = "test-subnet"
    #network_ip = "10.0.0.24"
    access_config {
      // Ephemeral IP
    }
  }
  metadata = {
    startup-script = <<SCRIPT
      #! /bin/bash
      sudo sed -i 's/.*127.0.1.1.*/127.0.1.1 ${var.instance_name}.personallab.local ${var.instance_name}/' /etc/hosts
      sudo realm join --verbose PERSONALLAB.LOCAL
      sudo realm permit -g AccAdminSecOpsServers@PERSONALLAB.LOCAL
      sudo realm permit -g domain\ admins@PERSONALLAB.LOCAL
      sudo sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g' /etc/sssd/sssd.conf
      sudo sh -c "echo 'entry_cache_timeout = 900' >> /etc/sssd/sssd.conf"
      sudo systemctl restart sssd.service
      SCRIPT
    shutdown-script = <<SCRIPT
      #! /bin/bash
      gcloud compute instances remove-metadata ${var.instance_name} --zone=${var.vm_zone} --keys=startup-script
      SCRIPT
  }
}
