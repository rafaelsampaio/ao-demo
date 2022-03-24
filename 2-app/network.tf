resource "google_compute_address" "app_address" {
  provider = google-beta
  name     = "${var.prefix}-app-address"
  labels   = local.labels
}

resource "google_compute_target_instance" "app_target" {
  provider = google-beta
  name     = "${var.prefix}-app-target"
  network  = var.app-target-network
  instance = var.app-target-instance
}

resource "google_compute_forwarding_rule" "app_fwd_rule" {
  provider   = google-beta
  name       = "${var.prefix}-app-fwd-rule"
  target     = google_compute_target_instance.app_target.id
  ip_address = google_compute_address.app_address.address
  labels     = local.labels
}

