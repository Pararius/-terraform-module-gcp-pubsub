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

variable "team" {
  type        = string
  default     = null
  description = "The team that owns the topic"

  validation {
    condition = contains([
      "analytics",
      "devops",
      "label-platform",
      "leadflow",
      "office",
      "scraper"
    ], var.team)
    error_message = "Unrecognized team, the following teams are allowed: ${join(", ", [
      "analytics",
      "devops",
      "label-platform",
      "leadflow",
      "office",
      "scraper",
    ])}"
  }
}

variable "environment" {
  type        = string
  description = "In what environment this topic belongs too"

  validation {
    condition = contains(["dev", "global", "production", "staging"], var.environment)
    error_message = "Unrecognized environment, the following environments are allowed: ${join(", ", [
      "dev",
      "global",
      "production",
      "staging",
    ])}"
  }
}

check "required" {
  assert {
    condition     = var.shared == true && var.team == null
    error_message = "When shared = true, team must be set to null"
  }
  assert {
    condition     = var.shared == false && var.team != null
    error_message = "When shared = false, team must be set to a valid team name"
  }
}
