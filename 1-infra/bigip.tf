# BIG-IP
# Setup Onboarding scripts
data "template_file" "startup_script" {
  template = file("${path.module}/startup-script.sh.tftpl")
  vars = {
    do-file = data.template_file.do_declaration.rendered

    mgmt_cidr    = var.mgmt-cidr
    mgmt_self    = var.bigip-mgmt-self
    mgmt_gateway = google_compute_subnetwork.mgmt_subnet.gateway_address
  }
}

data "template_file" "do_declaration" {
  template = file("${path.module}/do.json.tftpl")
  vars = {
    hostname = "${var.prefix}-${var.bigip-name}"
    passwd   = var.bigip-passwd
    timezone = var.bigip-timezone

    external_cidr    = var.external-cidr
    external_self    = var.bigip-external-self
    external_gateway = google_compute_subnetwork.external_subnet.gateway_address

    internal_cidr    = var.internal-cidr
    internal_self    = var.bigip-internal-self
    internal_gateway = google_compute_subnetwork.internal_subnet.gateway_address
  }
}


# Create F5 BIG-IP VMs
resource "google_compute_instance" "bigip" {
  name           = "${var.prefix}-aodemo-${var.bigip-name}"
  machine_type   = var.bigip-machine
  zone           = var.gcp-zone
  can_ip_forward = true

  labels = local.labels

  boot_disk {
    initialize_params {
      image = var.bigip-image
      size  = "128"
    }
  }

  #nic0 Management interface
  network_interface {
    network    = google_compute_network.mgmt_net.name
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    network_ip = var.bigip-mgmt-self
    access_config {}
  }

  #nic1 Data interface 1.1 - external
  network_interface {
    network    = google_compute_network.external_net.name
    subnetwork = google_compute_subnetwork.external_subnet.name
    network_ip = var.bigip-external-self
    access_config {}
  }

  #nic2 Data interface 1.2 - internal
  network_interface {
    network    = google_compute_network.internal_net.name
    subnetwork = google_compute_subnetwork.internal_subnet.name
    network_ip = var.bigip-internal-self
  }

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.startup_script.rendered
  }

  service_account {
    email  = var.gcp-svc-acct
    scopes = ["cloud-platform"]
  }
}
