resource "google_pubsub_topic" "topic" {
  for_each = toset(var.topic.externally_managed ? [] : [var.topic.name])

  labels  = local.labels
  name    = "${var.team}__${var.topic.name}"
  project = local.project
}

data "google_iam_policy" "topic" {
  for_each = toset(var.topic.externally_managed ? [] : [var.topic.name])

  binding {
    members = var.topic.publishers
    role    = "roles/pubsub.publisher"
  }
}

resource "google_pubsub_topic_iam_policy" "topic" {
  for_each = toset(var.topic.externally_managed ? [] : [var.topic.name])

  policy_data = data.google_iam_policy.topic[var.topic.name].policy_data
  project     = local.project
  topic       = google_pubsub_topic.topic[var.topic.name].name
}

data "google_pubsub_topic" "topic" {
  name    = var.topic.externally_managed ? var.topic.name : google_pubsub_topic.topic[var.topic.name].name
  project = local.project
}
