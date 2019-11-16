resource "aws_eip" "nat_one" {
  vpc      = true
  tags = {
    Name = "DLOS-NAT-ONE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_eip" "nat_two" {
  vpc      = true
  provider = "aws.ohio"
  tags = {
    Name = "DLOS-NAT-TWO",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}