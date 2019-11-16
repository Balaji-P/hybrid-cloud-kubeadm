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
}