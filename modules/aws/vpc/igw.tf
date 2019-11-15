resource "aws_internet_gateway" "gw" {
    count   =   length(aws_vpc.main)
    vpc_id = "${aws_vpc.main[count.index].id}"

    tags = {
        Name = "DLOS.${count.index}"
        Project =   "${var.Project}",
        TechnologyUnit  =   "${var.TechnologyUnit}",
        BusinessUnit    =   "${var.BusinessUnit}",
        Owner   =   "${var.Owner}"
  }
}