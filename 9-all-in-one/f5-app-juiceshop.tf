locals {
  app_labels_juiceshop = {
    owner       = "${var.prefix}-${var.tag_owner}"
    environment = "${var.prefix}-${var.tag_environment}"
    group       = "${var.prefix}-${var.tag_group}"
    application = "${var.prefix}-juiceshop"
    provider    = "${var.prefix}-terraform"
  }
}

resource "google_compute_instance" "app_juiceshop" {
  count        = 1
  name         = "${var.prefix}-juiceshop-${count.index}"
  machine_type = var.server_machine
  zone         = var.gcp_zone

  labels = local.app_labels_juiceshop

  boot_disk {
    initialize_params {
      image = var.server_image
      size  = "128"
    }
  }

  network_interface {
    network    = google_compute_network.internal_net.id
    subnetwork = google_compute_subnetwork.internal_subnet.id
    access_config {}
  }

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.startup_script.rendered
  }

}

resource "google_compute_address" "juiceshop" {
  provider = google-beta
  name     = "${var.prefix}-juiceshop-address"
  labels   = local.general_labels
}

resource "google_compute_target_instance" "juiceshop_target_bigip" {
  provider = google-beta
  name     = "${var.prefix}-juiceshop-target-bigip"
  network  = replace(google_compute_network.external_net.self_link, "v1", "beta")
  instance = google_compute_instance.f5_bigip.id
}

resource "google_compute_forwarding_rule" "juiceshop_fwd_rule" {
  provider   = google-beta
  name       = "${var.prefix}-juiceshop-fwd-rule"
  target     = google_compute_target_instance.juiceshop_target_bigip.id
  ip_address = google_compute_address.juiceshop.address
  all_ports  = true
  labels     = local.general_labels
}

resource "tls_private_key" "juiceshop_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "juiceshop_cert" {
  private_key_pem = tls_private_key.juiceshop_key.private_key_pem

  subject {
    common_name         = "juiceshop.example.com"
    organization        = "F5, Inc."
    organizational_unit = "Automation & Orchestration Toolchain Demo"
  }

  validity_period_hours = 168

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
