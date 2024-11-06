variable "topic" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "subscriptions" {
  type = list(object({
    acknowledge_deadline = number
    dead_letter_policy = optional(object({
      topic_name            = optional(string)
      max_delivery_attempts = optional(number)
    }))
    expiration_policy          = optional(string)
    labels                     = optional(map(string))
    message_retention_duration = optional(number)
    retain_acked_messages      = optional(bool)
    retry_policy = optional(object({
      minimum_backoff = optional(string, null)
      maximum_backoff = optional(string, null)
    }))
    subscription_name = string
  }))
}

variable "project" {
  type    = string
  default = null
}
