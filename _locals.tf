locals {
  subscriptions = {
    for subscription in var.subscriptions :
    subscription.subscription_name => subscription
  }
}
