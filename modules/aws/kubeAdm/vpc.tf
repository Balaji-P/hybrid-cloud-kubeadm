resource "aws_vpc" "vpc_one" {
    cidr_block       = "${lookup(var.CIDR, "vpc_one")}"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true


  tags = {
    Name = "DLOS-vpc_one",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_one_secondary_cidr" {
  vpc_id     = "${aws_vpc.vpc_one.id}"
  cidr_block = "10.200.0.0/16"
}

################ VPC TWO
resource "aws_vpc" "vpc_two" {
    cidr_block       = "${lookup(var.CIDR, "vpc_two")}"
    instance_tenancy = "default"
    provider = "aws.ohio"
    enable_dns_support = true
    enable_dns_hostnames = true


  tags = {
    Name = "DLOS-vpc_two",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_two_secondary_cidr" {
  provider = "aws.ohio"
  vpc_id     = "${aws_vpc.vpc_two.id}"
  cidr_block = "10.201.0.0/16"
}



######################## GCP
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
    "${cidrsubnet(lookup(var.CIDR, "vpc_three"),8,lookup(var.netnum_size, "worker"))}",
    "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "controller"))}",
    "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "worker"))}",
    "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "controller"))}",
    "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "worker"))}"
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
  target_tags = ["ssh"]
  }
