# BIG-IP
# Setup Onboarding scripts
data "template_file" "f5_runtime_script" {
  template = file("${path.module}/f5-runtime-init-script.tpl")
  vars = {
    do-file            = data.template_file.f5_do_declaration.rendered
    as3-juiceshop-file = data.template_file.f5_as3_juiceshop.rendered
    as3-dvwa-file      = data.template_file.f5_as3_dvwa.rendered
    as3-hackazon-file  = data.template_file.f5_as3_hackazon.rendered
    ts-file            = data.template_file.f5_ts_declaration.rendered
    mgmt-cidr          = var.mgmt_cidr
    mgmt-self          = var.bigip_mgmt_self
    mgmt-gateway       = google_compute_subnetwork.mgmt_subnet.gateway_address
    external-cidr      = var.external_cidr
    external-self      = var.bigip_external_self
    external-gateway   = google_compute_subnetwork.external_subnet.gateway_address
    internal-cidr      = var.internal_cidr
    internal-self      = var.bigip_internal_self
    internal-gateway   = google_compute_subnetwork.internal_subnet.gateway_address
  }
}

data "template_file" "f5_do_declaration" {
  template = file("${path.module}/f5-do.json.tpl")
  vars = {
    hostname = "${var.prefix}-${var.bigip_name}"
    passwd   = var.bigip_passwd
    timezone = var.bigip_timezone
  }
}



data "template_file" "f5_ts_declaration" {
  template = file("${path.module}/f5-ts.json.tpl")
  vars = {
    elastic_server = ""
  }
}

# Create F5 BIG-IP VMs
resource "google_compute_instance" "f5_bigip" {
  name           = "${var.prefix}-${var.bigip_name}"
  machine_type   = var.bigip_machine
  zone           = var.gcp_zone
  can_ip_forward = true

  labels = local.general_labels

  boot_disk {
    initialize_params {
      image = var.bigip_image
      size  = "128"
    }
  }

  #nic0 Management interface
  network_interface {
    network    = google_compute_network.mgmt_net.name
    subnetwork = google_compute_subnetwork.mgmt_subnet.name
    network_ip = var.bigip_mgmt_self
    access_config {}
  }

  #nic1 Data interface 1.1 - external
  network_interface {
    network    = google_compute_network.external_net.name
    subnetwork = google_compute_subnetwork.external_subnet.name
    network_ip = var.bigip_external_self
    access_config {}
  }

  #nic2 Data interface 1.2 - internal
  network_interface {
    network    = google_compute_network.internal_net.name
    subnetwork = google_compute_subnetwork.internal_subnet.name
    network_ip = var.bigip_internal_self
  }

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.f5_runtime_script.rendered
  }

  service_account {
    email  = var.gcp_svc_acct
    scopes = ["cloud-platform"]
  }
}
