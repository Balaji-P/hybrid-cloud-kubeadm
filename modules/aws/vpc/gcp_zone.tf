resource "google_dns_managed_zone" "private-zone" { 
  name        = "private-zone"
  dns_name    = "dlos-example.com."
  description = "Example private DNS zone"
  labels = {
    foo = "bar"
  }

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc_three.self_link
    }
  }
  
}

resource "google_dns_record_set" "gcp_kubeapi" {
  name = "kubeapi.${google_dns_managed_zone.private-zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.private-zone.name

  rrdatas = ["${substr((cidrsubnet(aws_subnet.vpc_one_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(aws_subnet.vpc_two_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(google_compute_subnetwork.controller.ip_cidr_range,8,11)),0, 9)}"]
}

resource "google_dns_record_set" "gcp_etcd" {
  name = "etcd.${google_dns_managed_zone.private-zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.private-zone.name

  rrdatas = ["${substr((cidrsubnet(aws_subnet.vpc_one_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(aws_subnet.vpc_two_controller.cidr_block,8,11)),0, 9)}","${substr((cidrsubnet(google_compute_subnetwork.controller.ip_cidr_range,8,11)),0, 9)}"]
}