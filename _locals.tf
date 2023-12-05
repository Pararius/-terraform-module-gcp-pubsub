locals {
  labels = merge(
    var.labels,
    {
      "environment" = var.environment
      "team"        = var.team
    },
  )

  environment_project_overrides = {
    "shared":     "treehouse-services-devops",
  }
  team_project_overrides = {
    "analytics": "treehouse-analyticsplatform",
  }
  project = coalesce(
    var.project_override,
    try(
      local.team_project_overrides[var.team],
      local.environment_project_overrides[var.environment],
      "treehouse-services-${var.environment}",
    ),
  )

  subscriptions = {
    for subscription in var.subscriptions :
    subscription.subscription_name => subscription
  }
}
