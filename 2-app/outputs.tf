output "serverAddresses" { value = google_compute_instance_from_machine_image.app.0.network_interface.0.network_ip }
output "virtualAddresses" { value = google_compute_address.app_address.address }