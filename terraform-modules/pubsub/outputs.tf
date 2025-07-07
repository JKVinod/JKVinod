output "topic" {
  value = google_pubsub_topic.events.name
}

output "subscription" {
  value = google_pubsub_subscription.handler.name
}
