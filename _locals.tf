locals {
  allowed_teams = [
    "analytics",
    "devops",
    "label-platform",
    "leadflow",
    "office",
    "scraper"
  ]
  allowed_environments = [
    "dev",
    "global",
    "production",
    "staging"
  ] 

  subscriptions = {
    for subscription in var.subscriptions :
    subscription.subscription_name => subscription
  }
  user_labels = { for k, v in var.labels : k => v if ! contains(["team", "environment", "shared"], k) }
  required_labels = merge(var.shared ? {"shared": "true"} : {"team": var.team}, {"environment": var.environment})
  labels = merge(user_labels, required_labels)
}
