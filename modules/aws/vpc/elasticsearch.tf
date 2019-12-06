resource "aws_instance" "vpc_one_elasticsearch" {
    ami           = "${data.aws_ami.ubuntu_vpc_one.id}"
    key_name  = "${aws_key_pair.vpc_one_deployer.key_name}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_one_elasticsearch.id}"]
    subnet_id   =   "${aws_subnet.vpc_one_elasticsearch.id}"
    private_ip  = "${substr((cidrsubnet(aws_subnet.vpc_one_elasticsearch.cidr_block,8,11)),0, 9)}"
    iam_instance_profile = "dlos-wrokers-ec2"
    #user_data = "${file("elasticsearchUserData.sh")}"

    depends_on = [
    "google_dns_record_set.gcp_kubeapi",
    "google_dns_record_set.gcp_etcd",
    "google_compute_vpn_tunnel.gcp-tunnel2",
    "google_compute_vpn_tunnel.gcp-tunnel1",
    "aws_route53_record.kubeapi",
    "aws_route53_record.etcd",
  ]
    

    root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
    volume_tags = {
      Name = "${format("%s","${var.Project}-${var.Environment}-Elasticsearch")}",
      Project =   "${var.Project}",
      TechnologyUnit  =   "${var.TechnologyUnit}",
      BusinessUnit    =   "${var.BusinessUnit}",
      Owner   =   "${var.Owner}",
      Cloud   =   "AWS",
      Component   =   "elasticsearch"

    }

    tags = {
    Name = "${format("%s","${var.Project}-${var.Environment}-elasticsearch")}",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}",
    Cloud   =   "AWS",
    Component   =   "elasticsearch"
  }
}

############### VPC TWO
resource "aws_instance" "vpc_two_elasticsearch" {
    provider = "aws.ohio"
    ami           = "${data.aws_ami.ubuntu_vpc_two.id}"
    key_name  = "${aws_key_pair.vpc_two_deployer.key_name}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_two_elasticsearch.id}"]
    subnet_id   =   "${aws_subnet.vpc_two_elasticsearch.id}"
    private_ip  = "${substr((cidrsubnet(aws_subnet.vpc_two_elasticsearch.cidr_block,8,11)),0, 9)}"
    iam_instance_profile = "dlos-wrokers-ec2"
    #user_data = "${file("elasticsearchUserData.sh")}"

    depends_on = [
    "google_dns_record_set.gcp_kubeapi",
    "google_dns_record_set.gcp_etcd",
    "google_compute_vpn_tunnel.gcp-tunnel2",
    "google_compute_vpn_tunnel.gcp-tunnel1",
    "aws_route53_record.kubeapi",
    "aws_route53_record.etcd",
  ]
    

    root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
    volume_tags = {
      Name = "${format("%s","${var.Project}-${var.Environment}-Elasticsearch")}",
      Project =   "${var.Project}",
      TechnologyUnit  =   "${var.TechnologyUnit}",
      BusinessUnit    =   "${var.BusinessUnit}",
      Owner   =   "${var.Owner}",
      Cloud   =   "AWS",
      Component   =   "elasticsearch"

    }

    tags = {
    Name = "${format("%s","${var.Project}-${var.Environment}-elasticsearch")}",
    Project =   "${var.Project}",
    TechnologyUnit  =   "${var.TechnologyUnit}",
    BusinessUnit    =   "${var.BusinessUnit}",
    Owner   =   "${var.Owner}",
    Cloud   =   "AWS",
    Component   =   "elasticsearch"
  }
}




############### GCP
resource "google_compute_address" "static_elasticsearch" {
  name = "controller-elasticsearch"
}
resource "google_compute_instance" "elasticsearch_instance" {
 name         = "dlos-elasticsearch"
 machine_type = "n1-standard-1"
 zone         = "us-east1-b"
 tags         = ["elasticsearch","ssh"]
 
 depends_on = [
    "google_dns_record_set.gcp_kubeapi",
    "google_dns_record_set.gcp_etcd",
    "google_compute_vpn_tunnel.gcp-tunnel2",
    "google_compute_vpn_tunnel.gcp-tunnel1",
    "aws_route53_record.kubeapi",
    "aws_route53_record.etcd",

  ]

 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190403"
     size = 50
     
   }
 }


# metadata_startup_script = "${file("controllerUserData.sh")}"

 network_interface {
   subnetwork = "${google_compute_subnetwork.elasticsearch.name}"
   network_ip   = "${substr((cidrsubnet(google_compute_subnetwork.elasticsearch.ip_cidr_range,8,11)),0, 9)}"

   access_config {
     // Include this section to give the VM an external ip address
     nat_ip = "${google_compute_address.static_elasticsearch.address}"
   }
 }

 metadata = {
    ssh-keys = "dlos:${file("~/.ssh/id_rsa.pub")}"
  }
 labels = {
    name = "${format("%s","${var.Project}-${var.Environment}-elasticsearch")}"
    project =   "${var.Project}"
    technologyunit  =   "${var.TechnologyUnit}"
    businessunit    =   "${var.BusinessUnit}"
    owner   =   "${var.Owner}"
    cloud   =   "gcp"
    component   =   "elasticsearch"
 }
}