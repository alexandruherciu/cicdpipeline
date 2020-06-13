resource "google_compute_instance" "default" {
  project      = "gke-test-279908"
  name         = "jenkins-tf"
  machine_type = "n1-standard-2"
  zone         = "europe-west3-a"
  
#  data "template_file" "rabbitmq_user_data" {
#  template = "${file("user_data.sh.tpl")}"
#
#  }  
  tags = ["jenkins"]
  metadata = {
    startup-script  = file("userdata.sh")
    fizz = "buzz"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
  resource "google_compute_firewall" "jenkins" {
  name    = "jenkins-firewall"
  network = "default" #google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["jenkins"]
}

#resource "google_compute_network" "default" {
#  name = "default"
#}