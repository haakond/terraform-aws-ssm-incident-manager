variable "primary_contact_display_name" {
  type        = string
  description = "Primary contact display name."
}

variable "primary_contact_alias" {
  type        = string
  description = "Primary contact alias."
}

variable "primary_contact_email_address" {
  type        = string
  description = "Valid email address (required)."
}

variable "primary_contact_phone_number" {
  type        = string
  description = "Valid phone number in format '+' followed by the country code and phone number."
}

variable "chatbot_sns_topic_notification_arn" {
  type        = string
  description = "Full ARN to SNS topic for AWS Chatbot notifications."
}

variable "rotation_start_time" {
  type        = string
  description = "SSM Incident Manager rotation schedule start time in ISO8601 format. Example. \"2024-06-24T08:00:00+00:00\"."
}

variable "replication_set_fallback_region" {
  type        = string
  default     = "eu-west-1"
  description = "Replication set fallback region."
}
