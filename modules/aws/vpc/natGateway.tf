resource "aws_nat_gateway" "vpc_one_natGateway" {
  allocation_id = "${aws_eip.nat_one.id}"
  subnet_id     = "${aws_subnet.vpc_one_controller.id}"
  
  tags = {
    Name = "DLOS-NATGATEWAY-VPC-ONE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_nat_gateway" "vpc_two_natGateway" {
  allocation_id = "${aws_eip.nat_two.id}"
  subnet_id     = "${aws_subnet.vpc_two_controller.id}"
  provider = "aws.ohio"
  
  tags = {
    Name = "DLOS-NATGATEWAY-VPC-TWO",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}



############## GCP
resource "google_compute_router" "router" {
  name    = "my-router"
  region  = google_compute_subnetwork.worker.region
  network = google_compute_network.vpc_three.self_link

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.worker.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
