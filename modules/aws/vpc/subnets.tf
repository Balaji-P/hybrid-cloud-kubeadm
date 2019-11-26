resource "aws_subnet" "vpc_one_worker" {
  vpc_id     = "${aws_vpc.vpc_one.id}"
  cidr_block = "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "worker"))}"
  

  tags = {
    Name = "DLOS-VPC-ONE-WORKER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_subnet" "vpc_one_controller" {
  vpc_id     = "${aws_vpc.vpc_one.id}"
  cidr_block = "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "controller"))}"
  

  tags = {
    Name = "DLOS-VPC-ONE-CONTROLLER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_subnet" "vpc_two_worker" {
  vpc_id     = "${aws_vpc.vpc_two.id}"
  cidr_block = "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "worker"))}"
  
  provider = "aws.ohio"

  tags = {
    Name = "DLOS-VPC-TWO-WORKER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_subnet" "vpc_two_controller" {
  vpc_id     = "${aws_vpc.vpc_two.id}"
  cidr_block = "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "controller"))}"
  
  provider = "aws.ohio"
  
  tags = {
    Name = "DLOS-VPC-TWO-CONTROLLER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
  
}