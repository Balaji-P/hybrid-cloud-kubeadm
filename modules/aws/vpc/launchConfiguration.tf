resource "aws_launch_configuration" "vpc_one_worker" {
  name_prefix          = "dlos-worker"
  image_id      = "${data.aws_ami.ubuntu_vpc_one.id}"
  instance_type = "t2.medium"
  iam_instance_profile = "dlos-wrokers-ec2"
  key_name  =   "${aws_key_pair.vpc_one_deployer.key_name}"
  security_groups =   ["${aws_security_group.vpc_one_worker.id}"]
  
  user_data = "${file("workersUserData.sh")}"
  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
}

resource "aws_launch_configuration" "vpc_two_worker" {
  provider = "aws.ohio"
  name_prefix          = "dlos-worker"
  image_id      = "${data.aws_ami.ubuntu_vpc_two.id}"
  instance_type = "t2.medium"
  iam_instance_profile = "dlos-wrokers-ec2"
  key_name  =   "${aws_key_pair.vpc_two_deployer.key_name}"
  security_groups =   ["${aws_security_group.vpc_two_worker.id}"]
  
  user_data = "${file("workersUserData.sh")}"
  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

}