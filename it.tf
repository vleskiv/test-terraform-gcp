

## Simple instance
#resource "google_compute_instance" "database" {
#  name         = "database"
#  machine_type = "n1-standard-1"
#  zone         = "us-west1-a"
#
#  tags = ["http-server"]
#
#  boot_disk {
#    initialize_params {
#      image = "ubuntu-os-cloud/ubuntu-1804-lts"
#    }
#  }
#
#  // Local SSD disk
#  scratch_disk {}
#
#  network_interface {
#    network = "default"
#
#    access_config {
#      // Ephemeral IP
#    }
#  }
#  metadata_startup_script = "sudo apt-get update"
#  metadata {
#    sshKeys = "ubuntu:${file(var.ssh_public_key_filepath)}"
#  }
#}



#resource "google_compute_disk" "default" {
#  name  = "test-disk"
#  type  = "pd-ssd"
##  zone  = "${element(var.zones, count.index)}"
#  size  = 10
#  labels = {
#    environment = "${var.env}"
#  }
#}
#
#resource "google_compute_attached_disk" "default" {
#  disk = "${google_compute_disk.default.self_link}"
#  instance = "${google_compute_instance.default.self_link}"
#}