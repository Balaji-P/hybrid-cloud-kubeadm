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