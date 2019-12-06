resource "aws_route_table" "vpc_one_controller_route" {
  vpc_id = "${aws_vpc.vpc_one.id}"
  
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw_one.id}"
  }


    tags = {
    Name = "DLOS-VPC-ONE-CONTROLLER-ROUTE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_route_table_association" "vpc_one_controller_association" {
  subnet_id      = "${aws_subnet.vpc_one_controller.id}"
  route_table_id = "${aws_route_table.vpc_one_controller_route.id}"
  
}


resource "aws_route_table" "vpc_two_controller_route" {
  vpc_id = "${aws_vpc.vpc_two.id}"
  provider = "aws.ohio"
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw_two.id}"
  }


    tags = {
    Name = "DLOS-VPC-TWO-CONTROLLER-ROUTE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_route_table_association" "vpc_two_controller_association" {
  subnet_id      = "${aws_subnet.vpc_two_controller.id}"
  route_table_id = "${aws_route_table.vpc_two_controller_route.id}"
  provider = "aws.ohio"
  
}



resource "aws_route_table" "vpc_one_worker_route" {
  vpc_id = "${aws_vpc.vpc_one.id}"
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.vpc_one_natGateway.id}"
  }


    tags = {
    Name = "DLOS-VPC-ONE-WORKER-ROUTE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_route_table_association" "vpc_one_worker_association" {
  subnet_id      = "${aws_subnet.vpc_one_worker.id}"
  route_table_id = "${aws_route_table.vpc_one_worker_route.id}"
  
}


resource "aws_route_table" "vpc_two_worker_route" {
  vpc_id = "${aws_vpc.vpc_two.id}"
  provider = "aws.ohio"
  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.vpc_two_natGateway.id}"
  }


    tags = {
    Name = "DLOS-VPC-TWO-WORKER-ROUTE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_route_table_association" "vpc_two_worker_association" {
  subnet_id      = "${aws_subnet.vpc_two_worker.id}"
  route_table_id = "${aws_route_table.vpc_two_worker_route.id}"
  provider = "aws.ohio"
  
}



###### define routes for VPC peering

resource "aws_route" "vpc_one_controller_route" {
  route_table_id            = "${aws_route_table.vpc_one_controller_route.id}"
  destination_cidr_block    = "${lookup(var.CIDR, "vpc_two")}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.DLOS-VPC-ONE.id}"
  depends_on                = ["aws_vpc_peering_connection_accepter.DLOS-VPC-TWO"]
  
}

resource "aws_route" "vpc_one_worker_route" {
  route_table_id            = "${aws_route_table.vpc_one_worker_route.id}"
  destination_cidr_block    = "${lookup(var.CIDR, "vpc_two")}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.DLOS-VPC-ONE.id}"
  depends_on                = ["aws_vpc_peering_connection_accepter.DLOS-VPC-TWO"]
  
}

resource "aws_route" "vpc_two_controller_route" {
  provider  = "aws.ohio"
  route_table_id            = "${aws_route_table.vpc_two_controller_route.id}"
  destination_cidr_block    = "${lookup(var.CIDR, "vpc_one")}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.DLOS-VPC-ONE.id}"
  depends_on                = ["aws_vpc_peering_connection_accepter.DLOS-VPC-TWO"]
  
}

resource "aws_route" "vpc_two_worker_route" {
  provider  = "aws.ohio"
  route_table_id            = "${aws_route_table.vpc_two_worker_route.id}"
  destination_cidr_block    = "${lookup(var.CIDR, "vpc_one")}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.DLOS-VPC-ONE.id}"
  depends_on                = ["aws_vpc_peering_connection_accepter.DLOS-VPC-TWO"]
  
}