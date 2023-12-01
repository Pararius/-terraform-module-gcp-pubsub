locals {
  labels = merge(
    var.labels,
    {
      "environment" = var.environment
      "team"        = var.team
    },
  )

  project = var.project_override != null ? var.project_override : var.team == "analytics" ? "treehouse-analyticsplatform" : var.environment == "shared" ? "treehouse-devops" : "treehouse-services-${var.environment}"

  subscriptions = {
    for subscription in var.subscriptions :
    subscription.subscription_name => subscription
  }
}
