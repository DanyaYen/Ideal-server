# --- Terraform Settings ---
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.0"
}

# --- Google Cloud Provider Configuration ---
provider "google" {
  project = "devops-474815" 
  region  = "europe-west3"        
  zone    = "europe-west3-c"      
}

# --- GCE Instance ---
resource "google_compute_instance" "ideal_server" {
  name         = "ideal-server-vm"
  machine_type = "e2-micro" 
  zone         = "europe-west3-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["allow-ssh", "allow-http", "allow-https"]

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  labels = {
    owner = "devops-pet-project"
  }
}

# --- Firewall Rules ---

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-ideal-server"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-ideal-server"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http"]
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https-ideal-server"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-https"]
}

# --- Outputs ---

output "instance_public_ip" {
  value       = google_compute_instance.ideal_server.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of the server."
}