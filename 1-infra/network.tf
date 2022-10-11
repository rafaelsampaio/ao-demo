# Networking
# VPC Management
resource "google_compute_network" "mgmt_net" {
  name                    = "${var.prefix}-aodemo-mgmt-net"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "mgmt_subnet" {
  name          = "${var.prefix}-aodemo-mgmt-subnet"
  ip_cidr_range = var.mgmt-cidr
  region        = var.gcp-region
  network       = google_compute_network.mgmt_net.name
}

# VPC External
resource "google_compute_network" "external_net" {
  name                    = "${var.prefix}-aodemo-external-net"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "external_subnet" {
  name          = "${var.prefix}-aodemo-external-subnet"
  ip_cidr_range = var.external-cidr
  region        = var.gcp-region
  network       = google_compute_network.external_net.name
}

# VPC Internal
resource "google_compute_network" "internal_net" {
  name                    = "${var.prefix}-aodemo-internal-net"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "internal_subnet" {
  name          = "${var.prefix}-aodemo-internal-subnet"
  ip_cidr_range = var.internal-cidr
  region        = var.gcp-region
  network       = google_compute_network.internal_net.name
}

# Firewall Rules
#VPC Management
resource "google_compute_firewall" "mgmt_allow_internal_traffic" {
  name          = "${var.prefix}-aodemo-mgmt-allow-internal-traffic"
  description   = "allow traffic internal Mgmt"
  network       = google_compute_network.mgmt_net.name
  source_ranges = [var.mgmt-cidr]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "mgmt_allow_myip" {
  name          = "${var.prefix}-aodemo-mgmt-allow-myip"
  description   = "allow my IP to access to Mgmt"
  network       = google_compute_network.mgmt_net.name
  source_ranges = ["${chomp(data.http.myip.response_body)}/32", "0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22", "443", "8443"]
  }
}

#VPC External
resource "google_compute_firewall" "external_allow_internal_traffic" {
  name          = "${var.prefix}-aodemo-external-allow-internal-traffic"
  description   = "allow traffic internal External"
  network       = google_compute_network.external_net.name
  source_ranges = [var.external-cidr]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "external_allow_myip" {
  name          = "${var.prefix}-aodemo-external-allow-myip"
  description   = "allow my IP to access External"
  network       = google_compute_network.external_net.name
  source_ranges = ["${chomp(data.http.myip.response_body)}/32","0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "app_ilb_probe" {
  name          = "${var.prefix}-aodemo-external-allow-ilb-probe"
  description   = "allow traffic from Google's probes to External"
  network       = google_compute_network.external_net.name
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "40000"]
  }
}

#VPC Internal
resource "google_compute_firewall" "internal_allow_internal_traffic" {
  name          = "${var.prefix}-aodemo-internal-allow-internal-traffic"
  description   = "allow traffic internal traffic in Internal"
  network       = google_compute_network.internal_net.name
  source_ranges = [var.internal-cidr]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "internal_allow_ssh" {
  name          = "${var.prefix}-aodemo-internal-allow-ssh"
  description   = "allow SSH from IAP to Internal"
  network       = google_compute_network.internal_net.name
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

