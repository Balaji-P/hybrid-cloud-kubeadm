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
   network_ip   = "10.2.1.12"

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