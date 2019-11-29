resource "aws_autoscaling_group" "vpc_one_worker" {
  name_prefix                 = "dlos-worker"
  launch_configuration = "${aws_launch_configuration.vpc_one_worker.name}"
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier   =   ["${aws_subnet.vpc_one_worker.id}"]

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]


  

  tags = [
    {
      "key" = "Name" 
      "value" = "${format("%s","${var.Project}-${var.Environment}-Worker")}"
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
      }
  ]
}

resource "aws_autoscaling_group" "vpc_two_worker" {
  provider  =   "aws.ohio"
  name_prefix                = "dlos-worker"
  launch_configuration = "${aws_launch_configuration.vpc_two_worker.name}"
  min_size             = 1
  max_size             = 2
  vpc_zone_identifier   =   ["${aws_subnet.vpc_two_worker.id}"]

  depends_on = [
    "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
  ]

  

  tags = [
    {
      "key" = "Name" 
      "value" = "${format("%s","${var.Project}-${var.Environment}-Worker")}"
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
      }
  ]
}




################## GCP #####################
resource "google_compute_autoscaler" "gcp_worker" {
  name   = "worker"
  zone   = "us-east1-b"
  target = google_compute_instance_group_manager.worker.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
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
  metadata_startup_script = "${file("workersUserData.sh")}"
  metadata = {
    cloud = "gcp",
    component = "worker"
    ssh-keys = "dlos:${file("~/.ssh/id_rsa.pub")}"
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