resource "aws_instance" "vpc_one_controller" {
    ami           = "${data.aws_ami.ubuntu_vpc_one.id}"
    key_name  = "${aws_key_pair.vpc_one_deployer.key_name}"
    instance_type = "t2.medium"
    security_groups =   ["${aws_security_group.vpc_one_controller.id}"]
    subnet_id   =   "${aws_subnet.vpc_one_controller.id}"
    private_ip  = "${substr((cidrsubnet(aws_subnet.vpc_one_controller.cidr_block,8,11)),0, 9)}"
    iam_instance_profile = "dlos-wrokers-ec2"
    user_data = "${file("controllerUserData.sh")}"
    

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
    private_ip  = "${substr((cidrsubnet(aws_subnet.vpc_two_controller.cidr_block,8,11)),0, 9)}"
    user_data = "${file("controllerUserData.sh")}"
    iam_instance_profile = "dlos-wrokers-ec2"
    

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




############### GCP
resource "google_compute_address" "static_controller" {
  name = "controller-public"
}
resource "google_compute_instance" "controller_instance" {
 name         = "dlos-controller"
 machine_type = "f1-micro"
 zone         = "us-east1-b"
 tags         = ["controller","ssh"]
 

 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190403"
     size = 50
     
   }
 }


 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   subnetwork = "${google_compute_subnetwork.controller.name}"
   network_ip   = "${substr((cidrsubnet(google_compute_subnetwork.controller.ip_cidr_range,8,11)),0, 9)}"

   access_config {
     // Include this section to give the VM an external ip address
     nat_ip = "${google_compute_address.static_controller.address}"
   }
 }

 metadata = {
    ssh-keys = "dlos:${file("~/.ssh/id_rsa.pub")}"
  }
 labels = {
    name = "${format("%s","${var.Project}-${var.Environment}-controller")}"
    project =   "${var.Project}"
    technologyunit  =   "${var.TechnologyUnit}"
    businessunit    =   "${var.BusinessUnit}"
    owner   =   "${var.Owner}"
    cloud   =   "gcp"
    component   =   "controller"
 }
}