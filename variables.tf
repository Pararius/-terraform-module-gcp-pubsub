variable "topic" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "subscriptions" {
  type = list(object({
    subscription_name          = string
    acknowledge_deadline       = number
    message_retention_duration = optional(number)
    labels                     = optional(map(string))
    retry_policy = optional(object({
      minimum_backoff = optional(number)
      maximum_backoff = optional(number)
    }))
  }))
}

variable "project" {
  type    = string
  default = null
}
