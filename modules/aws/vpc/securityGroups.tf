###### VPC ONE
resource "aws_security_group" "vpc_one_controller" {
  name        = "VPC-ONE-CONTROLLER"
  description = "Security Group For Controller"
  vpc_id      = "${aws_vpc.vpc_one.id}"

  tags = {
    Name = "DLOS-VPC-ONE-CONTROLLER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic internally"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "controller"))}"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic from Controller and Worker Groups"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "worker"))}", "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "worker"))}", "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "controller"))}"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow inbound https traffic"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_one_worker" {
  name        = "VPC-ONE-WORKER"
  description = "Security Group For Worker"
  vpc_id      = "${aws_vpc.vpc_one.id}"
  tags = {
    Name = "DLOS-VPC-ONE-WORKER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }


  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic internally"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "worker"))}"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic from Controller and Worker"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "controller"))}","${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "controller"))}", "${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "worker"))}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
###### VPC TWO
resource "aws_security_group" "vpc_two_controller" {
  provider  =   "aws.ohio"
  name        = "VPC-TWO-CONTROLLER"
  description = "Security Group For Controller"
  vpc_id      = "${aws_vpc.vpc_two.id}"
  tags = {
    Name = "DLOS-VPC-TWO-CONTROLLER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }

  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic internally"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "controller"))}"]
  }
  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic from Controller and Worker"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "worker"))}", "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "worker"))}", "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "controller"))}"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the inbound HTTPS traffic"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc_two_worker" {
    provider    =   "aws.ohio"
  name        = "VPC-TWO-WORKER"
  description = "Security Group For Worker"
  vpc_id      = "${aws_vpc.vpc_two.id}"
  tags = {
    Name = "DLOS-VPC-TWO-WORKER",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }

  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic internally"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "worker"))}"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    description =   "to allow the network traffic from Controller and Worker"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["${cidrsubnet(lookup(var.CIDR, "vpc_two"),8,lookup(var.netnum_size, "controller"))}","${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "controller"))}", "${cidrsubnet(lookup(var.CIDR, "vpc_one"),8,lookup(var.netnum_size, "worker"))}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}