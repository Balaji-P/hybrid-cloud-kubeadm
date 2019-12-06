resource "aws_internet_gateway" "gw_one" {
    vpc_id = "${aws_vpc.vpc_one.id}"
    

    tags = {
        Name = "DLOS-one"
        Project =   "${var.Project}",
        TechnologyUnit  =   "${var.TechnologyUnit}",
        BusinessUnit    =   "${var.BusinessUnit}",
        Owner   =   "${var.Owner}"
  }
}

resource "aws_internet_gateway" "gw_two" {
    vpc_id = "${aws_vpc.vpc_two.id}"
    
    provider = "aws.ohio"

    tags = {
        Name = "DLOS-two"
        Project =   "${var.Project}",
        TechnologyUnit  =   "${var.TechnologyUnit}",
        BusinessUnit    =   "${var.BusinessUnit}",
        Owner   =   "${var.Owner}"
  }
}