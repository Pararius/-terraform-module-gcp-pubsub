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

  message_retention_duration = each.value.message_retention_duration == null ? null : "${each.value.message_retention_duration}s"
  ack_deadline_seconds       = each.value.acknowledge_deadline
  labels                     = each.value.labels
}
