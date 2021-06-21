variable "topic" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "subscriptions" {
  type = list(object({
    subscription_name    = string
    acknowledge_deadline = number
    labels               = optional(map(string))
  }))
}

variable "project" {
  type    = string
  default = null
}
