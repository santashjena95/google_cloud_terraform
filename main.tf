resource "google_compute_address" "internal_ip" {
  name         = "my-internal-test"
  subnetwork   = "test-subnet"
  address_type = "INTERNAL"
  address      = "10.0.0.20"
  region       = "us-east4"
}
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
    email  = "terraform@pelagic-magpie-308310.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  network_interface {
    network = "test-vpc"
    subnetwork = "test-subnet"
    network_ip = google_compute_address.internal_ip.address
    access_config {
      // Ephemeral IP
    }
  }
  metadata = {
    startup-script = <<SCRIPT
      #! /bin/bash
      sudo sed -i 's/.*127.0.1.1.*/${google_compute_address.internal_ip.address} ${var.instance_name}.personallab.local ${var.instance_name}/' /etc/hosts
      sudo hostnamectl set-hostname ${var.instance_name}.personallab.local
      echo ${var.domain_password} | kinit -V ${var.domain_user}@PERSONALLAB.LOCAL
      echo ${var.domain_password} | sudo realm join --verbose --user=${var.domain_user} PERSONALLAB.LOCAL
      sudo realm permit -g AccAdminSecOpsServers@PERSONALLAB.LOCAL
      sudo realm permit -g domain\ admins@PERSONALLAB.LOCAL
      sudo sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g' /etc/sssd/sssd.conf
      sudo sh -c "echo 'entry_cache_timeout = 900' >> /etc/sssd/sssd.conf"
      sudo systemctl restart sssd.service
      sudo reboot
      SCRIPT
    shutdown-script = <<SCRIPT
      #! /bin/bash
      /home/jenasantash95/google-cloud-sdk/bin/gcloud compute instances remove-metadata ${var.instance_name} --zone=${var.vm_zone} --keys=startup-script,shutdown-script
      SCRIPT
  }
}
