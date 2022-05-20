resource "google_compute_address" "juiceshop" {
  provider = google-beta
  name     = "${var.prefix}-juiceshop-address"
  labels   = local.general_labels
}

resource "google_compute_target_instance" "juiceshop_target_bigip" {
  provider = google-beta
  name     = "${var.prefix}-juiceshop-target-bigip"
  network  = google_compute_network.external_net.self_link
  instance = google_compute_instance.f5_bigip.id
}

resource "google_compute_forwarding_rule" "juiceshop_fwd_rule" {
  provider   = google-beta
  name       = "${var.prefix}-juiceshop-fwd-rule"
  target     = google_compute_target_instance.juiceshop_target_bigip.id
  ip_address = google_compute_address.juiceshop.address
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

  validity_period_hours = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

data "template_file" "f5_as3_juiceshop" {
  template = file("${path.module}/f5-as3-tls-sd-waf-ts.json.tpl")

  vars = {
    app_tag         = "${var.prefix}-${var.tag_application}"
    app_region      = var.gcp_region
    app_certificate = replace(tls_self_signed_cert.juiceshop_cert.cert_pem, "/\n/", "\\n")
    app_private_key = replace(tls_private_key.juiceshop_key.private_key_pem, "/\n/", "\\n")

    app_tenant    = "juiceshop"
    app_name      = "juiceshop"
    app_address   = google_compute_address.juiceshop.address
    app_node_port = 8000
  }
}
