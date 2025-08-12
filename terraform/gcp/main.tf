terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.gcp_region
  initial_node_count = 1
  node_config {
    machine_type = "e2-medium"
  }
}

output "gke_kubeconfig" {
  value = google_container_cluster.primary.endpoint
}
