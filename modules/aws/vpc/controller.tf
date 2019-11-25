resource "aws_instance" "vpc_one_controller" {
    ami           = "${data.aws_ami.ubuntu_vpc_one.id}"
    key_name  = "${aws_key_pair.vpc_one_deployer.key_name}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_one_controller.id}"]
    subnet_id   =   "${aws_subnet.vpc_one_controller.id}"

    root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
    volume_tags = {
      Name = "${format("%s","${var.Project}-${var.Environment}-Controller")}",
      Project =   "${var.Project}",
      TechnologyUnit  =   "${var.TechnologyUnit}",
      BusinessUnit    =   "${var.BusinessUnit}",
      Owner   =   "${var.Owner}",
      Cloud   =   "AWS",
      Component   =   "Controller"

    }

    tags = {
    Name = "${format("%s","${var.Project}-${var.Environment}-controller")}",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
    Cloud   =   "AWS"
    Component   =   "controller"
  }
}

resource "aws_instance" "vpc_two_controller" {
    provider = "aws.ohio"
    key_name  = "${aws_key_pair.vpc_two_deployer.key_name}"
    ami           = "${data.aws_ami.ubuntu_vpc_two.id}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_two_controller.id}"]
    subnet_id   =   "${aws_subnet.vpc_two_controller.id}"

    root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
    volume_tags = {
      Name = "${format("%s","${var.Project}-${var.Environment}-Controller")}",
      Project =   "${var.Project}",
      TechnologyUnit  =   "${var.TechnologyUnit}",
      BusinessUnit    =   "${var.BusinessUnit}",
      Owner   =   "${var.Owner}",
      Cloud   =   "AWS",
      Component   =   "Controller"

    }

    tags = {
    Name = "${format("%s","${var.Project}-${var.Environment}-controller")}",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
    Cloud   =   "AWS"
    Component   =   "controller"
  }
}