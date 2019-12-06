resource "aws_route53_zone" "dlos_vpc" {
  name = "dlos-example.com"

  vpc {
    vpc_id = "${aws_vpc.vpc_one.id}"
  }

  tags = {
    Name = "DLOS-VPC",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}"
  }
}



resource "aws_route53_record" "etcd" {
  zone_id = "${aws_route53_zone.dlos_vpc.zone_id}"
  name    = "etcd.dlos-example.com"
  type    = "A"
  ttl     = "300"
  records = ["${substr((cidrsubnet(aws_subnet.vpc_one_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(aws_subnet.vpc_two_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(google_compute_subnetwork.controller.ip_cidr_range,8,11)),0, 9)}"]
}

resource "aws_route53_record" "kubeapi" {
  zone_id = "${aws_route53_zone.dlos_vpc.zone_id}"
  name    = "kubeapi.dlos-example.com"
  type    = "A"
  ttl     = "300"
  records = ["${substr((cidrsubnet(aws_subnet.vpc_one_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(aws_subnet.vpc_two_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(google_compute_subnetwork.controller.ip_cidr_range,8,11)),0, 9)}"]
}
resource "aws_route53_zone_association" "vpc_two_etcd" {
  provider = "aws.ohio"
  zone_id = "${aws_route53_zone.dlos_vpc.zone_id}"
  vpc_id  = "${aws_vpc.vpc_two.id}"
}




