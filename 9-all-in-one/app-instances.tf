data "template_file" "startup_script" {
  template = file("${path.module}/app-startup-script.tpl")
}

resource "google_compute_instance_from_machine_image" "app_dvwa" {
  count        = 1
  provider     = google-beta
  name         = "${var.prefix}-dvwa-${count.index}"
  machine_type = var.server_machine
  zone         = var.gcp_zone

  labels = local.app_labels_dvwa

  source_machine_image = var.server_image

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.startup_script.rendered
  }

  network_interface {
    network    = google_compute_network.internal_net.id
    subnetwork = google_compute_subnetwork.internal_subnet.id
  }
}

resource "google_compute_instance_from_machine_image" "app_hackazon" {
  count        = 1
  provider     = google-beta
  name         = "${var.prefix}-hackazon-${count.index}"
  machine_type = var.server_machine
  zone         = var.gcp_zone

  labels = local.app_labels_hackazon

  source_machine_image = var.server_image

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.startup_script.rendered
  }

  network_interface {
    network    = google_compute_network.internal_net.id
    subnetwork = google_compute_subnetwork.internal_subnet.id
  }
}

resource "google_compute_instance_from_machine_image" "app_juiceshop" {
  count        = 1
  provider     = google-beta
  name         = "${var.prefix}-juiceshop-${count.index}"
  machine_type = var.server_machine
  zone         = var.gcp_zone

  labels = local.app_labels_juiceshop

  source_machine_image = var.server_image

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.startup_script.rendered
  }

  network_interface {
    network    = google_compute_network.internal_net.id
    subnetwork = google_compute_subnetwork.internal_subnet.id
  }
}