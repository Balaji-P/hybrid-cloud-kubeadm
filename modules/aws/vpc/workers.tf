resource "aws_instance" "vpc_one_worker" {
    ami           = "${data.aws_ami.ubuntu_vpc_one.id}"
    key_name  = "${aws_key_pair.vpc_one_deployer.key_name}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_one_worker.id}"]
    subnet_id   =   "${aws_subnet.vpc_one_worker.id}"

    root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
    volume_tags = {
      Name = "${format("%s","${var.Project}-${var.Environment}-Worker")}",
      Project =   "${var.Project}",
      TechnologyUnit  =   "${var.TechnologyUnit}",
      BusinessUnit    =   "${var.BusinessUnit}",
      Owner   =   "${var.Owner}",
      Cloud   =   "AWS",
      Component   =   "worker"

    }

    tags = {
    Name = "${format("%s","${var.Project}-${var.Environment}-Worker")}",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}",
    Cloud   =   "AWS",
    Component   =   "worker"
  }
}

resource "aws_instance" "vpc_two_worker" {
    provider = "aws.ohio"
    ami           = "${data.aws_ami.ubuntu_vpc_two.id}"
    key_name  = "${aws_key_pair.vpc_two_deployer.key_name}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_two_worker.id}"]
    subnet_id   =   "${aws_subnet.vpc_two_worker.id}"

    root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
  volume_tags = {
      Name = "${format("%s","${var.Project}-${var.Environment}-Worker")}",
      Project =   "${var.Project}",
      TechnologyUnit  =   "${var.TechnologyUnit}",
      BusinessUnit    =   "${var.BusinessUnit}",
      Owner   =   "${var.Owner}",
      Cloud   =   "AWS",
      Component   =   "worker"

    }


    tags = {
    Name = "${format("%s","${var.Project}-${var.Environment}-Worker")}",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}",
    Cloud   =   "AWS",
    Component   =   "worker"
  }
}
