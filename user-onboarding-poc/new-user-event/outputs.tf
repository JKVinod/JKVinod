output "url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.trigger_handler.status[0].url
}
