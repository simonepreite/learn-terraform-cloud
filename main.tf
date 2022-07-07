provider "google" {
    project     = "formazione-simone-preite"
    #credentials = file("Path del file key.json") #se si esegue da console google non c'è bisogno delle credenziali
}

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "prima-vpc"
  auto_create_subnetworks = "false"
}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-1"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region #belgio
}

# Create a firewall rule that allows external SSH, ICMP:
resource "google_compute_firewall" "firewalli-ext" {
  name = "allow-ping-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a VM on GCP

resource "google_compute_instance" "default" {
  #count = 3
  name         = var.instance_name#-${count.index}"
  machine_type = var.instance_type
  zone         = "${var.region}-b"
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
    #source = google_compute_disk.boot-disk.name
  }

  network_interface {
    network = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
    }
  }
  desired_status = "RUNNING"
}
