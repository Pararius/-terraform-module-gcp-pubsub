data "google_project" "current" {}

resource "google_pubsub_subscription" "subscription" {
  for_each = local.subscriptions

  ack_deadline_seconds         = each.value.acknowledge_deadline
  enable_exactly_once_delivery = false
  enable_message_ordering      = false
  filter                       = ""
  labels                       = local.labels
  message_retention_duration   = each.value.message_retention_duration == null ? null : "${each.value.message_retention_duration}s"
  name                         = "${var.team}__${each.key}"
  project                      = local.project
  retain_acked_messages        = each.value.retain_acked_messages
  topic                        = data.google_pubsub_topic.topic.id

  dynamic "dead_letter_policy" {
    for_each = each.value.dead_letter_policy == null ? [] : [1]
    iterator = policy

    content {
      dead_letter_topic     = try(policy.topic_name, null)
      max_delivery_attempts = try(policy.max_delivery_attempts, null)
    }
  }

  expiration_policy {
    ttl = each.value.expiration_policy == null ? "" : each.value.expiration_policy
  }

  dynamic "push_config" {
    for_each = each.value.push_config == null ? [] : [1]
    iterator = config

    content {
      oidc_token {
        audience              = try(config.oidc_token.audience, null)
        service_account_email = try(config.oidc_token.service_account_email, null)
      }
      push_endpoint = try(config.push_endpoint, null)
    }
  }

  dynamic "retry_policy" {
    for_each = each.value.dead_letter_policy == null ? [] : [1]
    iterator = policy

    content {
      minimum_backoff = try(policy.minimum_backoff, null)
      maximum_backoff = try(policy.maximum_backoff, null)
    }
  }
}

data "google_iam_policy" "subscription" {
  for_each = local.subscriptions

  dynamic "binding" {
    for_each = lookup(each.value, "subscribers", [])
    iterator = subscriber

    content {
      members = [subscriber.value]
      role    = "roles/pubsub.subscriber"
    }
  }
}

resource "google_pubsub_subscription_iam_policy" "subscription" {
  for_each = local.subscriptions

  policy_data  = data.google_iam_policy.subscription[each.key].policy_data
  project      = local.project
  subscription = google_pubsub_subscription.subscription[each.key].name
}
