resource "google_compute_address" "dvwa" {
  provider = google-beta
  name     = "${var.prefix}-dvwa-address"
  labels   = local.general_labels
}

resource "google_compute_target_instance" "dvwa_target_bigip" {
  provider = google-beta
  name     = "${var.prefix}-dvwa-target-bigip"
  network  = google_compute_network.external_net.self_link
  instance = google_compute_instance.f5_bigip.id
}

resource "google_compute_forwarding_rule" "dvwa_fwd_rule" {
  provider   = google-beta
  name       = "${var.prefix}-dvwa-fwd-rule"
  target     = google_compute_target_instance.dvwa_target_bigip.id
  ip_address = google_compute_address.dvwa.address
  labels     = local.general_labels
}

resource "tls_private_key" "dvwa_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "dvwa_cert" {
  private_key_pem = tls_private_key.dvwa_key.private_key_pem

  subject {
    common_name         = "dvwa.example.com"
    organization        = "F5, Inc."
    organizational_unit = "Automation & Orchestration Toolchain Demo"
  }

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

data "template_file" "f5_as3_dvwa" {
  template = file("${path.module}/f5-as3-tls-sd-waf-ts.json.tpl")

  vars = {
    app_tag         = "${var.prefix}-dvwa"
    app_region      = var.gcp_region
    app_certificate = replace(tls_self_signed_cert.dvwa_cert.cert_pem, "/\n/", "\\n")
    app_private_key = replace(tls_private_key.dvwa_key.private_key_pem, "/\n/", "\\n")

    app_tenant    = "dvwa"
    app_name      = "dvwa"
    app_address   = google_compute_address.dvwa.address
    app_node_port = 8010
  }
}
