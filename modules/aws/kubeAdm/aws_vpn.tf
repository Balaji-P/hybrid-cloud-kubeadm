########## VPC ONE


resource "aws_vpn_gateway" "aws-vpn-gw-vpc-one" {
  vpc_id = "${aws_vpc.vpc_one.id}"
}

resource "aws_vpn_gateway_attachment" "vpn_attachment_vpc_one" {
  vpc_id         = "${aws_vpc.vpc_one.id}"
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw-vpc-one.id}"
}

resource "aws_vpn_gateway_route_propagation" "rp_vpc_one_controller" {
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw-vpc-one.id}"
  route_table_id = "${aws_route_table.vpc_one_controller_route.id}"
  depends_on = [
    "aws_vpn_connection.aws-vpn-connection-vpc-one",
  ]
}

resource "aws_vpn_gateway_route_propagation" "rp_vpc_one_worker" {
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw-vpc-one.id}"
  route_table_id = "${aws_route_table.vpc_one_worker_route.id}"
  depends_on = [
    "aws_vpn_connection.aws-vpn-connection-vpc-one",
  ]
}

resource "aws_customer_gateway" "aws-cgw-vpc-one" {
  bgp_asn    = 65000
  ip_address = "${google_compute_address.gcp-vpn-ip.address}"
  type       = "ipsec.1"
  tags = {
    Name = "DLOS-vpc_two",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpn_connection" "aws-vpn-connection-vpc-one" {
  vpn_gateway_id      = "${aws_vpn_gateway.aws-vpn-gw-vpc-one.id}"
  customer_gateway_id = "${aws_customer_gateway.aws-cgw-vpc-one.id}"
  type                = "ipsec.1"
  static_routes_only  = false
  tags = {
    Name = "DLOS-vpc_one",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}



########## VPC TWO


resource "aws_vpn_gateway" "aws-vpn-gw-vpc-two" {
  vpc_id = "${aws_vpc.vpc_two.id}"
  provider = "aws.ohio"
  tags = {
    Name = "DLOS-vpc_two",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment_vpc_two" {
  vpc_id         = "${aws_vpc.vpc_two.id}"
  provider = "aws.ohio"
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw-vpc-two.id}"
}

resource "aws_customer_gateway" "aws-cgw-vpc-two" {
  bgp_asn    = 65000
  ip_address = "${google_compute_address.gcp-vpn-ip.address}"
  type       = "ipsec.1"
  provider = "aws.ohio"
  tags = {
    Name = "DLOS-vpc_two",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpn_connection" "aws-vpn-connection-vpc-two" {
  vpn_gateway_id      = "${aws_vpn_gateway.aws-vpn-gw-vpc-two.id}"
  customer_gateway_id = "${aws_customer_gateway.aws-cgw-vpc-two.id}"
  type                = "ipsec.1"
  provider = "aws.ohio"
  static_routes_only  = false
  tags = {
    Name = "DLOS-vpc_two",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}



resource "aws_vpn_gateway_route_propagation" "rp_vpc_two_controller" {
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw-vpc-two.id}"
  route_table_id = "${aws_route_table.vpc_two_controller_route.id}"
  provider = "aws.ohio"
  depends_on = [
    "aws_vpn_connection.aws-vpn-connection-vpc-two",
  ]
}

resource "aws_vpn_gateway_route_propagation" "rp_vpc_two_worker" {
  vpn_gateway_id = "${aws_vpn_gateway.aws-vpn-gw-vpc-two.id}"
  route_table_id = "${aws_route_table.vpc_two_worker_route.id}"
  provider = "aws.ohio"
  depends_on = [
    "aws_vpn_connection.aws-vpn-connection-vpc-two",
  ]
}