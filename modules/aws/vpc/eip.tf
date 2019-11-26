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



##### EIP for controller Nodes

resource "aws_eip" "vpc_one_controller" {
  vpc      = true
  instance                  = "${aws_instance.vpc_one_controller.id}"
  associate_with_private_ip = "${substr((cidrsubnet(aws_subnet.vpc_one_controller.cidr_block,8,11)),0, 9)}"
  
  tags = {
    Name = "DLOS-CONTROLLER-ONE",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

resource "aws_eip" "vpc_two_controller" {
  vpc      = true
  instance                  = "${aws_instance.vpc_two_controller.id}"
  associate_with_private_ip = "${substr((cidrsubnet(aws_subnet.vpc_two_controller.cidr_block,8,11)),0, 9)}"
  
  provider = "aws.ohio"
  tags = {
    Name = "DLOS-CONTROLLER-TWO",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}