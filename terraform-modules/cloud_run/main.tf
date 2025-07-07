resource "google_cloud_run_service" "trigger_handler" {
  name     = var.name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
      service_account_name = var.service_account_email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.trigger_handler.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
