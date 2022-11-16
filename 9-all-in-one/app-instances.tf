data "template_file" "startup_script" {
  template = file("${path.module}/app-startup-script.sh.tftpl")
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