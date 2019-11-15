resource "aws_vpc" "main" {
    count   =   length(var.CIDR)
    cidr_block       = var.CIDR[count.index]
    instance_tenancy = "default"

  tags = {
    Name = "main",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}

output "VPC_ID" {
    value   =   aws_vpc.main[*].id
    description = "VPC_IDS"
}