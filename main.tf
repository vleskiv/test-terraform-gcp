resource "google_compute_instance" "database" {
  name         = "database"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  // Local SSD disk
  scratch_disk {}

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  metadata_startup_script = "sudo apt-get update"
  metadata {
    sshKeys = "ubuntu:${file(var.ssh_public_key_filepath)}"
  }
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}