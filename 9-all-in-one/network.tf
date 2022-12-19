#Networking
#VPC Management
resource "google_compute_network" "mgmt_net" {
  name                    = "${var.prefix}-mgmt-net"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "mgmt_subnet" {
  name          = "${var.prefix}-mgmt-subnet"
  ip_cidr_range = var.mgmt_cidr
  region        = var.gcp_region
  network       = google_compute_network.mgmt_net.name
}

#VPC External
resource "google_compute_network" "external_net" {
  name                    = "${var.prefix}-external-net"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "external_subnet" {
  name          = "${var.prefix}-external-subnet"
  ip_cidr_range = var.external_cidr
  region        = var.gcp_region
  network       = google_compute_network.external_net.name
}

#VPC Internal
resource "google_compute_network" "internal_net" {
  name                    = "${var.prefix}-internal-net"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "internal_subnet" {
  name          = "${var.prefix}-internal-subnet"
  ip_cidr_range = var.internal_cidr
  region        = var.gcp_region
  network       = google_compute_network.internal_net.name
}

#Firewall Rules
#VPC Management
resource "google_compute_firewall" "mgmt_allow_traffic" {
  name          = "${var.prefix}-mgmt-allow-traffic"
  description   = "allow traffic in Mgmt network"
  network       = google_compute_network.mgmt_net.name
  source_ranges = [var.mgmt_cidr]
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
  name          = "${var.prefix}-mgmt-allow-myip"
  description   = "allow my IP to access to Mgmt"
  network       = google_compute_network.mgmt_net.name
  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }
}


#VPC External
resource "google_compute_firewall" "external_allow_traffic" {
  name          = "${var.prefix}-external-allow-traffic"
  description   = "allow traffic in External network"
  network       = google_compute_network.external_net.name
  source_ranges = [var.external_cidr]
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
  name          = "${var.prefix}-external-allow-myip"
  description   = "allow my IP to access External"
  network       = google_compute_network.external_net.name
  source_ranges = ["${chomp(data.http.myip.response_body)}/32"]
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "app_ilb_probe" {
  name          = "${var.prefix}-external-allow-ilb-probe"
  description   = "allow traffic from Google's probes to External"
  network       = google_compute_network.external_net.name
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "40000"]
  }
}

#VPC Internal
resource "google_compute_firewall" "internal_allow_traffic" {
  name          = "${var.prefix}-internal-allow-traffic"
  description   = "allow traffic in Internal"
  network       = google_compute_network.internal_net.name
  source_ranges = [var.internal_cidr]
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
  name          = "${var.prefix}-internal-allow-ssh"
  description   = "allow SSH from IAP to Internal"
  network       = google_compute_network.internal_net.name
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
