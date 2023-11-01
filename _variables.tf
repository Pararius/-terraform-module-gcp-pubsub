variable "topic" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = {}
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
      minimum_backoff = optional(number)
      maximum_backoff = optional(number)
    }))
    subscription_name = string
  }))
}

variable "project" {
  type    = string
  default = null
}

variable "shared" {
  type        = bool
  default     = false
  description = "Set to true if this topic ownership is shared between differents teams, i.e. different teams publish to it"
}

variable "_allowed_environments" {
  default = [
    "dev",
    "global",
    "production",
    "staging"
  ]
}

variable "_allowed_teams" {
  default = [
    "analytics",
    "devops",
    "label-platform",
    "leadflow",
    "office",
    "scraper"
  ]
}

variable "team" {
  type        = string
  default     = null
  description = "The team that owns the topic"

  validation {
    condition     = var.shared == false && contains(var._allowed_teams, var.team)
    error_message = "Unrecognized team, the following teams are allowed: ${join(", ", var._allowed_teams)}"
  }
}

variable "environment" {
  type        = string
  description = "In what environment this topic belongs too"

  validation {
    condition     = contains(var._allowed_environments, var.environment)
    error_message = "Unrecognized environment, the following environments are allowed: ${join(", ", var._allowed_environments)}"
  }
}
