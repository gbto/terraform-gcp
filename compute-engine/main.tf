/* Create the Virtual Private Cloud network and subnet */
resource "google_compute_network" "vpc_network" {
  name                    = "${var.namespace}-custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
  project                 = var.project_id
}

resource "google_compute_subnetwork" "default" {
  name          = "${var.namespace}-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  project       = var.project_id
}

/* Create a single Compute Engine instance */
resource "google_compute_instance" "default" {
  name         = "flask-vm"
  machine_type = "f1-micro"
  zone         = var.zone
  tags         = ["ssh"]
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}