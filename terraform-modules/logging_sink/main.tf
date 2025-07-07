resource "google_logging_project_sink" "workspace_events" {
  name        = var.sink_name
  destination = var.destination
  filter      = var.filter
  unique_writer_identity = true
}
