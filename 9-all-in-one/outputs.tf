# Outputs
output "bigip" { value = "https://${google_compute_instance.f5_bigip.network_interface.0.access_config.0.nat_ip}" }
output "juiceshop" { value = "https://${google_compute_address.juiceshop.address}" }
