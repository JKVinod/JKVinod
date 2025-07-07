variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "GCP VPC Network"
  type        = string
}

variable "subnetwork" {
  description = "GCP Subnetwork"
  type        = string
}

variable "trigger_handler_image" {
  description = "Container image for Cloud Run trigger handler"
  type        = string
}

variable "argo_workflows_api" {
  description = "Argo Workflows API endpoint"
  type        = string
}

variable "cloud_run_service_account" {
  description = "Service account email for Cloud Run to authenticate to Pub/Sub"
  type        = string
}
