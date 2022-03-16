# Outputs
#My IP address for management
#output "myip" { value = chomp(data.http.myip.body) }

#GCP outputs
#output "gcp_mgmt_net_id" { value = google_compute_network.mgmt_net.id }
#output "gcp_mgmt_subnet_id" { value = google_compute_subnetwork.mgmt_subnet.id }
#output "gcp_mgmt_subnet" { value = google_compute_subnetwork.mgmt_subnet.ip_cidr_range }

#output "gcp_external_net_id" { value = google_compute_network.external_net.id }
#output "gcp_external_subnet_id" { value = google_compute_subnetwork.external_subnet.id }
#output "gcp_external_subnet" { value = google_compute_subnetwork.external_subnet.ip_cidr_range }

#output "gcp_internal_net_id" { value = google_compute_network.internal_net.id }
#output "gcp_internal_subnet_id" { value = google_compute_subnetwork.internal_subnet.id }
#output "gcp_internal_subnet" { value = google_compute_subnetwork.internal_subnet.ip_cidr_range }

#BIG-IP outputs
#output "bigip_id" { value = google_compute_instance.bigip.id }
#output "bigip_mgmt_ip" { value = google_compute_instance.bigip.network_interface.0.network_ip }
output "bigip-address" { value = google_compute_instance.bigip.network_interface.0.access_config.0.nat_ip }
output "bigip-gui" { value = "https://${google_compute_instance.bigip.network_interface.0.access_config.0.nat_ip}" }
#output "bigip_internal_ip" { value = google_compute_instance.bigip.network_interface.2.network_ip }
#output "bigip_external_ip" { value = google_compute_instance.bigip.network_interface.1.network_ip }
#output "bigip_external_ip_public" { value = google_compute_instance.bigip.network_interface.1.access_config.0.nat_ip }
