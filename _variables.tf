variable "environment" {
  type = string

  validation {
    condition = contains(
      [
        "global",
        "production",
        "shared",
        "staging",
      ],
      var.environment
    )
    error_message = "Invalid environment: ${var.environment}"
  }
}

variable "labels" {
  default = null
  type    = map(string)
}

variable "project_override" {
  default = null
  type    = string
}

variable "subscriptions" {
  type = list(object({
    acknowledge_deadline = optional(number)
    dead_letter_policy = optional(object({
      topic_name            = optional(string)
      max_delivery_attempts = optional(number)
    }))
    expiration_policy          = optional(string)
    message_retention_duration = optional(number)
    push_config = optional(object({
      oidc_token = optional(object({
        service_account_email = optional(string)
        audience              = optional(string)
      }))
      push_endpoint = optional(string)
    }))
    retain_acked_messages = optional(bool)
    retry_policy = optional(object({
      minimum_backoff = optional(number)
      maximum_backoff = optional(number)
    }))
    subscribers       = optional(list(string))
    subscription_name = string
  }))
}

variable "topic" {
  type = object({
    externally_managed = optional(bool)
    name               = string
    publishers         = optional(list(string))
  })
}

variable "team" {
  type = string

  validation {
    condition = contains(
      [
        # Actual teams
        "aanbod",
        "analytics",
        "devops",
        "leadflow",
        "pararius-office",
        "scraper",
        "website",
        # Not team specific
        "global",
        "shared",
      ],
      var.team
    )
    error_message = "Invalid team: ${var.team}"
  }
}
