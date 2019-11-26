resource "google_compute_subnetwork" "controller" {
  name          =  "${format("%s","${var.Project}-${var.Environment}-controller")}"
  ip_cidr_range = "${cidrsubnet(lookup(var.CIDR, "vpc_three"),8,lookup(var.netnum_size, "controller"))}"
  network       = "${google_compute_network.vpc_three.name}"
}
resource "google_compute_subnetwork" "worker" {
  name          =  "${format("%s","${var.Project}-${var.Environment}-worker")}"
  ip_cidr_range = "${cidrsubnet(lookup(var.CIDR, "vpc_three"),8,lookup(var.netnum_size, "worker"))}"
  network      = "${google_compute_network.vpc_three.name}"
}

