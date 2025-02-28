variable "subscription_id" {
  description = "The ID of the subscription"
  type        = string
}

variable "subscription_name" {
  description = "The name of the subscription"
  type        = string
}
variable "allowed_locations" {
  description = "List of allowed locations"
  type        = list(string)
}