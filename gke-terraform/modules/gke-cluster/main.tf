resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  network    = var.vpc_id
  subnetwork = var.private_subnet

  remove_default_node_pool = true
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.admin_cidr
      display_name = "admin-access"
    }
  }

  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_project_iam_binding" "gke_admin" {
  project = var.project_id
  role    = "roles/container.clusterAdmin"
  members = var.admins
}
