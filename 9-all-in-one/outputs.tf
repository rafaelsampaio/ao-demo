# Outputs
output "bigip-mgmt-ip" { value = google_compute_instance.f5_bigip.network_interface.0.access_config.0.nat_ip }
output "bigip-mgmt-url" { value = "https://${google_compute_instance.f5_bigip.network_interface.0.access_config.0.nat_ip}" }
output "bigip-ext-ip" { value = google_compute_instance.f5_bigip.network_interface.1.access_config.0.nat_ip }
output "juiceshop-ip" { value = google_compute_address.juiceshop.address }
output "juiceshop-url" { value = "https://${google_compute_address.juiceshop.address}" }
