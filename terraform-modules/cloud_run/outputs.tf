output "url" {
  value = google_cloud_run_service.trigger_handler.status[0].url
}
