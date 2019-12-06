resource "aws_vpc_peering_connection" "DLOS-VPC-ONE" {
  peer_vpc_id   = "${aws_vpc.vpc_two.id}"
  vpc_id        = "${aws_vpc.vpc_one.id}"
  peer_region   =   "${element(split(":", aws_vpc.vpc_two.arn), 3)}"
  auto_accept   = false

  tags = {
    Name = "VPC Peering between VPC-ONE and VPC-TWO"
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpc_peering_connection_accepter" "DLOS-VPC-TWO" {
  provider                  = "aws.ohio"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.DLOS-VPC-ONE.id}"
  auto_accept               = true
  


  tags = {
    Name = "VPC Peering between VPC-ONE and VPC-TWO"
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}