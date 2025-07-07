terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# ----------------------------
# MODULE: Logging Sink
# ----------------------------
module "logging_sink" {
  source      = "../terraform-terraform-modules/logging_sink"
  sink_name   = "user-creation-sink"
  filter      = "resource.type=\"audited_resource\" AND protoPayload.methodName=\"google.admin.directory.user.create\""
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${var.pubsub_topic_name}"
  project_id  = var.project_id
}

# ----------------------------
# MODULE: Pub/Sub
# ----------------------------
module "pubsub" {
  source       = "./terraform-modules/pubsub"
  topic_name   = var.pubsub_topic_name
  subscription = {
    name         = "user-events-sub"
    push         = true
    push_url     = module.cloud_run.url
    ack_deadline = 10
  }
}

# ----------------------------
# MODULE: Cloud Run Trigger
# ----------------------------
module "cloud_run" {
  source                = "./terraform-modules/cloud_run"
  name                  = "trigger-handler"
  region                = var.region
  image                 = var.trigger_handler_image
  service_account_email = var.cloud_run_service_account
}

# ----------------------------
# MODULE: GKE Cluster
# ----------------------------
module "gke" {
  source         = "./terraform-modules/gke-cluster"
  name           = "devops-cluster"
  region         = var.region
  project_id     = var.project_id
  node_count     = 2
  machine_type   = "e2-medium"
}

# ----------------------------
# MODULE: Argo Workflows via Helm
# ----------------------------
module "argo_workflows" {
  source           = "./terraform-modules/argo_workflows"
  namespace        = "argo"
  gke_cluster_name = module.gke.cluster_name
  project_id       = var.project_id
  location         = var.region
}

# ----------------------------
# IAM Bindings
# ----------------------------
resource "google_pubsub_subscription_iam_member" "cloud_run_invoker" {
  subscription = module.pubsub.subscription_name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.cloud_run_service_account}"
}
