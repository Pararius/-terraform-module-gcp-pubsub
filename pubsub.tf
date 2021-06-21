resource "google_pubsub_topic" "topic" {
  project = var.project
  name    = var.topic

  labels = var.labels
}

resource "google_pubsub_subscription" "subscription" {
  for_each = local.subscriptions

  project = var.project
  name    = each.key
  topic   = google_pubsub_topic.topic.name

  ack_deadline_seconds = each.value.acknowledge_deadline
  labels               = each.value.labels
}
