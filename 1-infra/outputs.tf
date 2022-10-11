# Outputs
output "console-bigip-name" {
  description = "use this output to access the console"
  value       = google_compute_instance.bigip.name
}
output "console-bigip-zone" {
  description = "use this output to access the console"
  value       = google_compute_instance.bigip.zone
}
output "bigip-address" {
  description = "use this output to configure the your bigip-address in part 3"
  value       = google_compute_instance.bigip.network_interface.0.access_config.0.nat_ip
}
output "bigip-gui" {
  description = "use this output to access your bigip instance"
  value       = "https://${google_compute_instance.bigip.network_interface.0.access_config.0.nat_ip}"
}
output "app-target-instance" {
  description = "use this output to configure the your var app-target-instance in part 2"
  value       = google_compute_instance.bigip.self_link
}
output "app-target-network" {
  description = "use this output to configure the your var app-target-network in part 2"
  value       = google_compute_network.external_net.self_link
}
output "server-network" {
  description = "use this output to configure the your var server-network in part 2"
  value       = google_compute_network.internal_net.self_link
}
output "server-subnetwork" {
  description = "use this output to configure the your var server-subnetwork in part 2"
  value       = google_compute_subnetwork.internal_subnet.self_link
}