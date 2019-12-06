resource "aws_autoscaling_group" "vpc_one_worker" {
  name_prefix                 = "dlos-worker"
  launch_configuration = "${aws_launch_configuration.vpc_one_worker.name}"
  min_size             = 1
  max_size             = 5
  desired_capacity     = 5
  vpc_zone_identifier   =   ["${aws_subnet.vpc_one_worker.id}"]

  depends_on = [
    "google_dns_record_set.gcp_kubeapi",
    "google_dns_record_set.gcp_etcd",
    "google_compute_vpn_tunnel.gcp-tunnel2",
    "google_compute_vpn_tunnel.gcp-tunnel1",
    "aws_route53_record.kubeapi",
    "aws_route53_record.etcd",
  ]

  tags = [
    {
      "key" = "Name" 
      "value" = "${format("%s","${var.Project}-${var.Environment}-Worker")}"
      "propagate_at_launch" = true
      },
      {
       "key"  = "pod-cidr"
       "value"  = "${aws_vpc_ipv4_cidr_block_association.vpc_one_secondary_cidr.cidr_block}"
       "propagate_at_launch" = true

     }, 
    {
      "key" = "Project"
      "value" =   "${var.Project}"
      "propagate_at_launch" = true
      },
    {
      "key" = "TechnologyUnit"
      "value"  =   "${var.TechnologyUnit}"
      "propagate_at_launch" = true
      },
    {
      "key" = "BusinessUnit"
      "value"    =   "${var.BusinessUnit}"
      "propagate_at_launch" = true
      },
    {
      "key" = "Owner"   
      "value" =   "${var.Owner}"
      "propagate_at_launch" = true
      },
    {
      "key" = "Cloud"
      "value"   =   "AWS"
      "propagate_at_launch" = true
      },
    {
      "key" = "Component"
      "value"   =   "worker"
      "propagate_at_launch" = true
      },
    {
      "key" = "kubernetes.io/cluster/dlos"
      "value" = "owned"
      "propagate_at_launch" = true
      }
  ]
}
resource "aws_autoscaling_policy" "autopolicy_vpc_one_worker" {
name = "terraform-autoplicy"
scaling_adjustment = 1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = "${aws_autoscaling_group.vpc_one_worker.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
alarm_name = "terraform-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "60"

dimensions = {
AutoScalingGroupName = "${aws_autoscaling_group.vpc_one_worker.name}"
}

alarm_description = "This metric monitor EC2 instance cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.autopolicy_vpc_one_worker.arn}"]
}

resource "aws_autoscaling_group" "vpc_two_worker" {
  provider  =   "aws.ohio"
  name_prefix                = "dlos-worker"
  launch_configuration = "${aws_launch_configuration.vpc_two_worker.name}"
  min_size             = 1
  max_size             = 5
  desired_capacity     = 5
  vpc_zone_identifier   =   ["${aws_subnet.vpc_two_worker.id}"]

  depends_on = [
    "google_dns_record_set.gcp_kubeapi",
    "google_dns_record_set.gcp_etcd",
    "google_compute_vpn_tunnel.gcp-tunnel2",
    "google_compute_vpn_tunnel.gcp-tunnel1",
    "aws_route53_record.kubeapi",
    "aws_route53_record.etcd",
  ]

  tags = [
    {
      "key" = "name" 
      "value" = "${format("%s","${var.Project}-${var.Environment}-Worker")}"
      "propagate_at_launch" = true
      },

     {
       "key"  = "pod-cidr"
       "value"  = "${aws_vpc_ipv4_cidr_block_association.vpc_two_secondary_cidr.cidr_block}"
       "propagate_at_launch" = true

     }, 
    {
      "key" = "project"
      "value" =   "${var.Project}"
      "propagate_at_launch" = true
      },
    {
      "key" = "technologyunit"
      "value"  =   "${var.TechnologyUnit}"
      "propagate_at_launch" = true
      },
    {
      "key" = "businessunit"
      "value"    =   "${var.BusinessUnit}"
      "propagate_at_launch" = true
      },
    {
      "key" = "owner"   
      "value" =   "${var.Owner}"
      "propagate_at_launch" = true
      },
    {
      "key" = "cloud"
      "value"   =   "AWS"
      "propagate_at_launch" = true
      },
    {
      "key" = "component"
      "value"   =   "worker"
      "propagate_at_launch" = true
      },
    {
      "key" = "kubernetes.io/cluster/dlos"
      "value" = "owned"
      "propagate_at_launch" = true
      }
  ]
}

resource "aws_autoscaling_policy" "autopolicy_vpc_two_worker" {
name = "terraform-autoplicy"
provider  =   "aws.ohio"
scaling_adjustment = 1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = "${aws_autoscaling_group.vpc_two_worker.name}"
}

resource "aws_cloudwatch_metric_alarm" "vpc_two_worker_cpualarm" {
provider  =   "aws.ohio"
alarm_name = "terraform-alarm"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "60"

dimensions = {
AutoScalingGroupName = "${aws_autoscaling_group.vpc_two_worker.name}"
}

alarm_description = "his metric monitor EC2 instance cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.autopolicy_vpc_two_worker.arn}"]
}



################## GCP #####################
resource "google_compute_autoscaler" "gcp_worker" {
  name   = "worker"
  zone   = "us-east1-b"
  target = google_compute_instance_group_manager.worker.self_link

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }

  depends_on = [
    "google_dns_record_set.gcp_kubeapi",
    "google_dns_record_set.gcp_etcd",
    "google_compute_vpn_tunnel.gcp-tunnel2",
    "google_compute_vpn_tunnel.gcp-tunnel1",
    "aws_route53_record.kubeapi",
    "aws_route53_record.etcd",
  ]
}

resource "google_compute_instance_template" "gcp_worker_template" {
  name           = "worker"
  machine_type   = "f1-micro"
  can_ip_forward = false

  tags = ["worker", "gcp", "ssh"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-bionic-v20190403"
  }

  network_interface {
   subnetwork = "${google_compute_subnetwork.worker.name}"
 }
  metadata_startup_script = "${file("workersUserData_gcp.sh")}"
  metadata = {
    cloud = "gcp"
    component = "worker"
    ssh-keys = "dlos:${file("~/.ssh/id_rsa.pub")}"
    pod-cidr = "${cidrsubnet("10.200.0.0/16",8,3)}"

  }
  labels = {
    name = "${format("%s","${var.Project}-${var.Environment}-worker")}"
    project =   "${var.Project}"
    technologyunit  =   "${var.TechnologyUnit}"
    businessunit    =   "${var.BusinessUnit}"
    owner   =   "${var.Owner}"
    cloud   =   "gcp"
    component   =   "worker"
 }

}

resource "google_compute_target_pool" "worker" {
  name = "worker"
}

resource "google_compute_instance_group_manager" "worker" {
  name = "worker"
  zone = "us-east1-b"

  version {
    instance_template  = google_compute_instance_template.gcp_worker_template.self_link
    name               = "primary"
  }

  target_pools       = [google_compute_target_pool.worker.self_link]
  base_instance_name = "worker"
}