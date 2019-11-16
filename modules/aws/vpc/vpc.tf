resource "aws_vpc" "vpc_one" {
    cidr_block       = "${lookup(var.CIDR, "vpc_one")}"
    instance_tenancy = "default"


  tags = {
    Name = "DLOS-vpc_one",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_vpc" "vpc_two" {
    cidr_block       = "lookup(var.CIDR, "vpc_two")"
    instance_tenancy = "default"


  tags = {
    Name = "DLOS-vpc_two",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}
