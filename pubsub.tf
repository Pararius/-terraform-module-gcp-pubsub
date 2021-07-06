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

  dynamic "retry_policy" {
    for_each = each.value.dead_letter_policy == null ? [] : [1]
    iterator = policy

    content {
      minimum_backoff = try(policy.minimum_backoff, null)
      maximum_backoff = try(policy.maximum_backoff, null)
    }
  }
}

data "google_project" "current" {}
