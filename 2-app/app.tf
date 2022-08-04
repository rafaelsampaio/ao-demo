data "template_file" "startup_script" {
  template = file("${path.module}/startup-script.sh.tftpl")
}

resource "google_compute_instance_from_machine_image" "app" {
  count        = 1
  provider     = google-beta
  name         = "${var.prefix}-aodemo-server-${count.index}"
  machine_type = var.server-machine
  zone         = var.gcp-zone

  labels = local.labels

  source_machine_image = var.server-image

  metadata = {
    serial-port-enable = true
    startup-script     = data.template_file.startup_script.rendered
  }

  network_interface {
    network    = var.server-network
    subnetwork = var.server-subnetwork
  }

}

