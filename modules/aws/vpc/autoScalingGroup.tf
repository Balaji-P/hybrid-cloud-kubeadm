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