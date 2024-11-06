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

  ack_deadline_seconds       = each.value.acknowledge_deadline
  labels                     = each.value.labels
  message_retention_duration = each.value.message_retention_duration == null ? null : "${each.value.message_retention_duration}s"
  retain_acked_messages      = each.value.retain_acked_messages

  dynamic "dead_letter_policy" {
    for_each = each.value.dead_letter_policy == null ? [] : [each.value.dead_letter_policy]
    iterator = policy

    content {
      dead_letter_topic = try(
        regex("^projects/[^/]+/topics/", policy.value.topic_name) == "" ? "${data.google_project.current.id}/topics/${policy.value.topic_name}" : policy.value.topic_name,
        null
      )
      max_delivery_attempts = try(policy.value.max_delivery_attempts, null)
    }
  }

  expiration_policy {
    ttl = each.value.expiration_policy == null ? "" : each.value.expiration_policy
  }

  dynamic "retry_policy" {
    for_each = each.value.retry_policy == null ? [] : [each.value.retry_policy]
    iterator = policy

    content {
      minimum_backoff = policy.value.minimum_backoff
      maximum_backoff = policy.value.maximum_backoff
    }
  }
}

data "google_project" "current" {}
