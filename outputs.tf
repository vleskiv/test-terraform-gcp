output "assigned_nat_ip" {
  value = "${google_compute_instance.database.network_interface.0.access_config.0.assigned_nat_ip}"
}
output "nat_ip" {
  value = "${google_compute_instance.database.network_interface.0.access_config.0.nat_ip}"
}