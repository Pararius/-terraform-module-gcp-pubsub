output "subscriptions" {
  value = google_pubsub_subscription.subscription
}

output "topic" {
  value = data.google_pubsub_topic.topic
}
