resource "google_compute_network" "vpc_three" {
  name          =  "${format("%s","${var.Project}-${var.Environment}-vpc")}"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.Project}-fw-allow-internal"
  network = "${google_compute_network.vpc_three.name}"
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
  source_ranges = [
    "${cidrsubnet(lookup(var.CIDR, "vpc_three"),8,lookup(var.netnum_size, "controller"))}",
    "${cidrsubnet(lookup(var.CIDR, "vpc_three"),8,lookup(var.netnum_size, "worker"))}"
  ]
}
resource "google_compute_firewall" "allow-http" {
  name    = "${var.Project}-fw-allow-http"
  network = "${google_compute_network.vpc_three.name}"
allow {
    protocol = "tcp"
    ports    = ["6443"]
  }
  target_tags = ["controller"] 
}
resource "google_compute_firewall" "allow-bastion" {
  name    = "${var.Project}-fw-allow-bastion"
  network = "${google_compute_network.vpc_three.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["controller","worker"]
  }