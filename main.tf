

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

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "${var.name}-global-forwarding-rule"
  project    = "${var.project}"
  target     = "${google_compute_target_http_proxy.target_http_proxy.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name        = "${var.name}-proxy"
  project     = "${var.project}"
  url_map     = "${google_compute_url_map.url_map.self_link}"
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  project         = "${var.project}"
  default_service = "${google_compute_backend_service.backend_service.self_link}"
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.name}-backend-service"
  project               = "${var.project}"
  port_name             = "http"
  protocol              = "HTTP"
  backend {
    group                 = "${google_compute_instance_group_manager.webservers.instance_group}"
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }

  health_checks = ["${google_compute_http_health_check.healthcheck.self_link}"]
}

resource "google_compute_http_health_check" "healthcheck" {
  name         = "${var.name}-healthcheck"
  project      = "${var.project}"
  port         = 80
  request_path = "/"
}

resource "google_compute_instance_group_manager" "webservers" {
  name               = "${var.name}-instance-group-manager"
  project            = "${var.project}"
  instance_template  = "${google_compute_instance_template.webserver_instance_template.self_link}"
  base_instance_name = "${var.name}-webserver-instance"

  zone               = "${element(var.zones, count.index)}"
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_instance_template" "webserver_instance_template" {
  name         = "${var.name}-instance-template"
  project      = "${var.project}"
  machine_type = "${var.instance_type}"
  region       = "${var.region}"

  metadata {
    ssh-keys = "${var.user}:${file("${var.ssh_public_key_filepath}")}"
  }

  disk {
    source_image = "${var.image}"
    auto_delete  = true
    boot         = true
  }

  disk {
    auto_delete  = false
    boot         = false
    disk_type    = "pd-ssd"
    disk_name    = "test-disk"
    disk_size_gb = 10
    device_name  = "sdb"
  }

  network_interface {
    network            = "${var.network_name}"
    access_config {
      # Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
  }

#  metadata_startup_script = "${data.template_file.init.rendered}"
  metadata_startup_script = "sudo apt-get update && sudo apt install nginx && sudo service nginx start"

  tags = ["http-server"]

  labels = {
    environment = "${var.env}"
  }
}

resource "google_compute_autoscaler" "autoscaler" {
  name    = "${var.name}-scaler"
  project = "${var.project}"
#  count   = "1"
  zone    = "${element(var.zones, count.index)}"
  target  = "${element(google_compute_instance_group_manager.webservers.*.self_link, count.index)}"

  autoscaling_policy = {
    max_replicas    = 1
    min_replicas    = 1
    cooldown_period = 90

    cpu_utilization {
      target = 0.8
    }
  }
}