output "app-node-ip" { value = google_compute_instance_from_machine_image.app.0.network_interface.0.network_ip }
output "app-address" { value = google_compute_address.app_address.address }