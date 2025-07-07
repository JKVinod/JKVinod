resource "google_pubsub_topic" "events" {
  name = var.topic_name
}

resource "google_pubsub_subscription" "handler" {
  name  = var.subscription_name
  topic = google_pubsub_topic.events.name

  push_config {
    push_endpoint = var.push_endpoint
  }
}