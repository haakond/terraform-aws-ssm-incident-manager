variable "primary_contact_display_name" {
  type        = string
  description = "Primary contact display name."
}

variable "primary_contact_email_address" {
  type        = string
  description = "Valid email address (required)."
}

variable "primary_contact_phone_number" {
  type        = string
  description = "Valid phone number in format '+' followed by the country code and phone number."
}

variable "escalation_contact_display_name" {
  type        = string
  description = "Escalation contact display name."
}

variable "escalation_contact_email_address" {
  type        = string
  description = "Valid email address (required)."
}

variable "sns_topic_notification_arn" {
  type        = string
  description = "Full ARN to SNS topic for notifications."
}
