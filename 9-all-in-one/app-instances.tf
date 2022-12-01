data "template_file" "startup_script" {
  template = file("${path.module}/app-startup-script.sh")
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