# Outputs
output "bigip-address" { value = google_compute_instance.bigip.network_interface.0.access_config.0.nat_ip }
output "bigip-gui" { value = "https://${google_compute_instance.bigip.network_interface.0.access_config.0.nat_ip}" }
