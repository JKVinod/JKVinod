terraform {
  required_version = ">= 1.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.7"
    }
  }
  backend "gcs" {
    bucket  = var.state_bucket
    prefix  = var.state_prefix
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    host                   = module.gke.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

data "google_client_config" "default" {}
